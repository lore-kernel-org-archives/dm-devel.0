From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: dracut: multipath module
Date: Wed, 3 Apr 2019 21:59:59 +0200
Message-ID: <a839ad11-96fa-73a0-fb58-ba589cfa61c9@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-GB
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, initramfs <initramfs@vger.kernel.org>, Dave Young <dyoung@redhat.com>, Harald Hoyer <harald@redhat.co>
List-Id: dm-devel.ids

Hi,


This only works in a Fedora/RH distribution:


- dracut/modules.d/90multipath/module-setup.sh:97:        [ -n "$_allow" ] && mpathconf $_allow --outfile ${initdir}/etc/multipath.conf
                                                                              ^^^^^^^^^
   https://src.fedoraproject.org/rpms/device-mapper-multipath/blob/master/f/0012-RH-add-mpathconf.patch


- dracut/modules.d/90multipath/multipathd.sh:3:if getargbool 1 rd.multipath -d -n rd_NO_MULTIPATH && [ -e /etc/multipath.conf ]; then
                                                                                                     ^^^^^^^^^^^^^^^^^^^^^^^^^^
- dracut/modules.d/90multipath/multipathd-stop.sh:3:if [ -e /etc/multipath.conf ]; then
                                                       ^^^^^^^^^^^^^^^^^^^^^^^^^^
   https://src.fedoraproject.org/rpms/device-mapper-multipath/blob/master/f/0010-RH-don-t-start-without-a-config-file.patch
