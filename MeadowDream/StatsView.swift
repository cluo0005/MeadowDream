//
//  StatsView.swift
//  MeadowDream

import SwiftUI
import Charts

struct StatsView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @StateObject private var userSession = UserSessionManager.shared
    @State private var dreams: [Dream] = []
    @State private var isLoading = true
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    headerView
                    
                    // Stats Cards
                    statsCardsView
                    
                    // Dream Frequency Chart
                    dreamFrequencyChart
                    
                    Spacer(minLength: 100) // Space for bottom navigation
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
            }
            .background(Color(.systemBackground))
            .navigationBarHidden(true)
            .onAppear {
                loadDreams()
            }
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        HStack {
            Text("Stats")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.primary)
            
            Spacer()
        }
        .padding(.bottom, 8)
    }
    
    // MARK: - Stats Cards
    private var statsCardsView: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
            // Total Dreams
            StatCard(
                value: "\(totalDreams)",
                label: "Total Dreams",
                color: Color(red: 0.357, green: 0.498, blue: 1.0)
            )
            
            // This Month
            StatCard(
                value: "\(dreamsThisMonth)",
                label: "This Month",
                color: Color(red: 0.357, green: 0.498, blue: 1.0)
            )
            
            // Average per Week
            StatCard(
                value: String(format: "%.1f", averagePerWeek),
                label: "Avg per Week",
                color: Color(red: 0.357, green: 0.498, blue: 1.0)
            )
            
            // Longest Streak
            StatCard(
                value: "\(longestStreak)",
                label: "Longest Streak",
                color: Color(red: 0.357, green: 0.498, blue: 1.0)
            )
        }
    }
    
    // MARK: - Dream Frequency Chart
    private var dreamFrequencyChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Dream Frequency")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(colorScheme == .dark ? .white : .black)
            
            if isLoading {
                // Loading state
                HStack {
                    Spacer()
                    VStack(spacing: 12) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: colorScheme == .dark ? .white : .black))
                        Text("Loading chart data...")
                            .font(.system(size: 14))
                            .foregroundColor(colorScheme == .dark ? .white.opacity(0.7) : .black.opacity(0.7))
                    }
                    Spacer()
                }
                .frame(height: 200)
            } else if #available(iOS 16.0, *) {
                Chart(monthlyData) { item in
                    LineMark(
                        x: .value("Month", item.month),
                        y: .value("Dreams", item.count)
                    )
                    .foregroundStyle(Color(red: 0.357, green: 0.498, blue: 1.0))
                    .lineStyle(StrokeStyle(lineWidth: 3))
                    
                    PointMark(
                        x: .value("Month", item.month),
                        y: .value("Dreams", item.count)
                    )
                    .foregroundStyle(Color(red: 0.357, green: 0.498, blue: 1.0))
                    .symbolSize(50)
                }
                .frame(height: 200)
                .chartXAxis {
                    AxisMarks(values: .automatic) { _ in
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                            .foregroundStyle(colorScheme == .dark ? .white.opacity(0.2) : .black.opacity(0.2))
                        AxisTick(stroke: StrokeStyle(lineWidth: 0.5))
                            .foregroundStyle(colorScheme == .dark ? .white.opacity(0.5) : .black.opacity(0.5))
                        AxisValueLabel()
                            .foregroundStyle(colorScheme == .dark ? .white.opacity(0.7) : .black.opacity(0.8))
                            .font(.system(size: 12))
                    }
                }
                .chartYAxis {
                    AxisMarks(values: .automatic) { _ in
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                            .foregroundStyle(colorScheme == .dark ? .white.opacity(0.2) : .black.opacity(0.2))
                        AxisTick(stroke: StrokeStyle(lineWidth: 0.5))
                            .foregroundStyle(colorScheme == .dark ? .white.opacity(0.5) : .black.opacity(0.5))
                        AxisValueLabel()
                            .foregroundStyle(colorScheme == .dark ? .white.opacity(0.7) : .black.opacity(0.8))
                            .font(.system(size: 12))
                    }
                }
                .chartPlotStyle { plotArea in
                    plotArea
                        .background(.clear)
                }
            } else {
                // Fallback for iOS 15 - Simple bar chart representation
                VStack(spacing: 8) {
                    HStack(alignment: .bottom, spacing: 8) {
                        ForEach(monthlyData, id: \.month) { item in
                            VStack(spacing: 4) {
                                // Bar
                                Rectangle()
                                    .fill(Color(red: 0.357, green: 0.498, blue: 1.0))
                                    .frame(width: 30, height: max(CGFloat(item.count) * 20, 5))
                                    .clipShape(RoundedRectangle(cornerRadius: 4))
                                
                                // Month label
                                Text(item.month)
                                    .font(.system(size: 10))
                                    .foregroundColor(colorScheme == .dark ? .white.opacity(0.7) : .black.opacity(0.7))
                                
                                // Count label
                                Text("\(item.count)")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                            }
                        }
                    }
                    .frame(height: 160)
                    
                    Text("Dreams per month (last 7 months)")
                        .font(.system(size: 12))
                        .foregroundColor(colorScheme == .dark ? .white.opacity(0.7) : .black.opacity(0.7))
                }
                .frame(height: 200)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
        )
    }
    
    // MARK: - Computed Properties
    private var totalDreams: Int {
        dreams.count
    }
    
    private var dreamsThisMonth: Int {
        let calendar = Calendar.current
        let now = Date()
        return dreams.filter { dream in
            calendar.isDate(dream.dateCreated, equalTo: now, toGranularity: .month)
        }.count
    }
    
    private var averagePerWeek: Double {
        guard !dreams.isEmpty else { return 0.0 }
        
        let calendar = Calendar.current
        let now = Date()
        
        // Get the earliest dream date
        guard let earliestDream = dreams.min(by: { $0.dateCreated < $1.dateCreated }) else {
            return 0.0
        }
        
        let daysBetween = calendar.dateComponents([.day], from: earliestDream.dateCreated, to: now).day ?? 0
        let weeksBetween = max(Double(daysBetween) / 7.0, 1.0) // At least 1 week
        
        return Double(totalDreams) / weeksBetween
    }
    
    private var longestStreak: Int {
        guard !dreams.isEmpty else { return 0 }
        
        let calendar = Calendar.current
        let sortedDreams = dreams.sorted { $0.dateCreated < $1.dateCreated }
        
        var currentStreak = 1
        var maxStreak = 1
        
        for i in 1..<sortedDreams.count {
            let previousDate = sortedDreams[i-1].dateCreated
            let currentDate = sortedDreams[i].dateCreated
            
            let daysBetween = calendar.dateComponents([.day], from: previousDate, to: currentDate).day ?? 0
            
            if daysBetween <= 2 { // Allow for 1-2 day gaps
                currentStreak += 1
                maxStreak = max(maxStreak, currentStreak)
            } else {
                currentStreak = 1
            }
        }
        
        return maxStreak
    }
    
    private var monthlyData: [MonthlyDreamData] {
        let calendar = Calendar.current
        let now = Date()
        
        // Get last 7 months
        var data: [MonthlyDreamData] = []
        
        for i in stride(from: 6, through: 0, by: -1) {
            guard let monthDate = calendar.date(byAdding: .month, value: -i, to: now) else { continue }
            
            let monthName = DateFormatter().monthSymbols[calendar.component(.month, from: monthDate) - 1]
            let shortMonth = String(monthName.prefix(3))
            
            let dreamsInMonth = dreams.filter { dream in
                calendar.isDate(dream.dateCreated, equalTo: monthDate, toGranularity: .month)
            }.count
            
            data.append(MonthlyDreamData(month: shortMonth, count: dreamsInMonth))
        }
        
        return data
    }
    
    // MARK: - Actions
    private func loadDreams() {
        guard let currentUserID = userSession.currentUserID else {
            isLoading = false
            return
        }
        
        let localDreams = LocalDataManager.shared.fetchDreams(forUserID: currentUserID)
        self.dreams = localDreams.map { Dream(from: $0) }
        isLoading = false
    }
}

// MARK: - Supporting Views
struct StatCard: View {
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(color)
            
            Text(label)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

struct MonthlyDreamData: Identifiable {
    let id = UUID()
    let month: String
    let count: Int
}

// Fallback chart for iOS 15
struct SimpleLineChart: View {
    let data: [Int]
    
    var body: some View {
        GeometryReader { geometry in
            let maxValue = data.max() ?? 1
            let stepX = geometry.size.width / CGFloat(max(data.count - 1, 1))
            let stepY = geometry.size.height / CGFloat(maxValue)
            
            ZStack {
                // Grid lines
                ForEach(0..<5) { i in
                    let y = geometry.size.height * CGFloat(i) / 4
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                    }
                    .stroke(Color.white.opacity(0.2), lineWidth: 0.5)
                }
                
                // Line chart
                Path { path in
                    for (index, value) in data.enumerated() {
                        let x = CGFloat(index) * stepX
                        let y = geometry.size.height - (CGFloat(value) * stepY)
                        
                        if index == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                }
                .stroke(Color(red: 0.357, green: 0.498, blue: 1.0), lineWidth: 3)
                
                // Data points
                ForEach(Array(data.enumerated()), id: \.offset) { index, value in
                    let x = CGFloat(index) * stepX
                    let y = geometry.size.height - (CGFloat(value) * stepY)
                    
                    Circle()
                        .fill(Color(red: 0.357, green: 0.498, blue: 1.0))
                        .frame(width: 8, height: 8)
                        .position(x: x, y: y)
                }
            }
        }
    }
}

#Preview {
    StatsView()
} 