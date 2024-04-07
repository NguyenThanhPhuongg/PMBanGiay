
package repository;

import java.awt.CardLayout;
import java.awt.Dimension;
import java.util.List;
import javax.swing.JPanel;
import javax.swing.table.DefaultTableModel;
import model.HoaDon;
import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartPanel;
import org.jfree.chart.JFreeChart;
import org.jfree.data.category.DefaultCategoryDataset;
import service.ThongKeService;
import service.ThongKeServiceImpl;

public class QuanLyThongKeController {
    private ThongKeService thongKeService = null;

    public QuanLyThongKeController() {
        thongKeService = new ThongKeServiceImpl();
    }
    public void setDateToChart(JPanel jPanel){
        List<HoaDon> list = thongKeService.getListByHoaDon();
        if(list != null){
        DefaultCategoryDataset dataset = new DefaultCategoryDataset();
            for (HoaDon item : list) {
                dataset.addValue(item.getTongTien(), "Doanh thu", item.getNgayTao());
            }
            JFreeChart chart = ChartFactory.createBarChart("Thong ke doanh thu ban hang"
                    , "Thoi gian", "Tong tien", dataset);
            ChartPanel chartPanel = new ChartPanel(chart);
            chartPanel.setPreferredSize(new Dimension(jPanel.getWidth(),500));
            jPanel.removeAll();
            jPanel.setLayout(new CardLayout());
            jPanel.add(chartPanel);
            jPanel.validate();
            jPanel.repaint();
        }        
    }
}
