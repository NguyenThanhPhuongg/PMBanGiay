
package service;

import java.util.List;
import model.HoaDon;
import repository.ThongKeDAO;
import repository.ThongKeDAOImpl;

public class ThongKeServiceImpl implements ThongKeService{
    private ThongKeDAO thongKeDAO = null;

    public ThongKeServiceImpl() {
        thongKeDAO = new ThongKeDAOImpl();
    }
    
    @Override
    public List<HoaDon> getListByHoaDon() {
        return thongKeDAO.getListByHoaDon();
    }
    
}
