
package repository;

import java.util.List;
import model.HoaDon;
import model.HoaDonChiTiet;
import model.SanPham;

public interface ThongKeDAO {
    public List<HoaDon> getListByHoaDon();
    public List<HoaDonChiTiet> getListBySanPham();
}
