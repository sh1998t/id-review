abstract class RoutesName {
  static const loginName = 'login';
  static const loginPath = '/login';

  static const servicesName = 'services';
  static const servicesPath = '/services';

  static const renewalName = 'renewal';
  static const renewalPath = '/renewal/:serviceType';

  static String renewal(String serviceType) => '/renewal/$serviceType';
}
