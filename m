From: Dmitry Ivanov <divanov@vtsystems.com>
Subject: IO monitoring of dm devices with iostat
Date: Mon, 11 Jan 2010 13:50:11 +0300
Message-ID: <4B4B0263.4030308@vtsystems.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

	Hello!
Can you help me with iostat monitoring of /dev/dm-* and /dev/sd* 
devices.  Main question is about understanding of tps value. For example 
/dev/dm-5 is a dm-mapper-device based on /dev/sde and /dev/sdc.  tps 
value of dm-5 is 30% bigger than sde+sdf. According to stats from 
storage, right TPS io value is sde+sdf. Why /dev/dm* values differ while 
other columns are the same? How to treat this numbers?
	Thank you!

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
            0.16    0.00    0.08    0.02    0.00   99.73

Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
sda               0.50         0.00         0.01          0          0
sda1              0.00         0.00         0.00          0          0
sda2              0.50         0.00         0.01          0          0
sdb               0.00         0.00         0.00          0          0
sdb1              0.00         0.00         0.00          0          0
sdc               0.43         0.00         0.01          0          0
sdc1              0.00         0.00         0.00          0          0
sdc2              0.43         0.00         0.01          0          0
sdd               0.00         0.00         0.00          0          0
sdd1              0.00         0.00         0.00          0          0
sde              38.00         0.00         0.25          0          7
sde1             38.00         0.00         0.25          0          7
sdf              38.50         0.00         0.25          0          7
sdf1             38.50         0.00         0.25          0          7
dm-0              3.70         0.00         0.01          0          0
dm-1              0.00         0.00         0.00          0          0
dm-2              3.70         0.00         0.01          0          0
dm-3              3.70         0.00         0.01          0          0
dm-4              0.00         0.00         0.00          0          0
dm-5            126.43         0.00         0.49          0         14
dm-6            126.43         0.00         0.49          0         14
dm-7              0.00         0.00         0.00          0          0
dm-8              0.00         0.00         0.00          0          0



-- 
