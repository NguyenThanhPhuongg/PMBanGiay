package repository;

import java.util.List;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import model.HoaDon;
import model.HoaDonChiTiet;
import model.SanPham;

public class ThongKeDAOImpl implements ThongKeDAO {

    public List<HoaDon> getListByHoaDon() {
        try {
            Connection conn = DBConnect.getConnection();
            String query = "SELECT NgayTao, sum(TongTien) as tongTien FROM HoaDon group by NgayTao";
            List<HoaDon> list = new ArrayList<>();
            PreparedStatement statement = conn.prepareCall(query);
            ResultSet rs = statement.executeQuery();
            while (rs.next()) {
                HoaDon hoaDon = new HoaDon();
                hoaDon.setNgayTao(rs.getDate("NgayTao"));
                hoaDon.setTongTien(rs.getDouble("tongTien"));
                list.add(hoaDon);
            }
            return list;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<HoaDonChiTiet> getListBySanPham() {
        try {
            Connection conn = DBConnect.getConnection();
            String query = """
                           SELECT NgayTao,sum(SoLuongSP) as SoLuongSP FROM HoaDon 
                           join HoaDonChiTiet on HoaDonChiTiet.ID_HoaDon = HoaDon.ID group by NgayTao
                           """;
            List<HoaDonChiTiet> list = new ArrayList<>();
            PreparedStatement statement = conn.prepareCall(query);
            ResultSet rs = statement.executeQuery();
            while (rs.next()) {
                HoaDonChiTiet hdct = new HoaDonChiTiet();
                hdct.setSoLuong(rs.getInt("SoLuongSP"));
//                hdct.setHd(rs.getDate("NgayTao"));
                list.add(hdct);
            }
            return list;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
