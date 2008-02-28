From: "Pradipmaya Maharana" <pradipmaya@gmail.com>
Subject: Installing RHEL with single controller
Date: Thu, 28 Feb 2008 10:08:28 -0800
Message-ID: <110b17190802281008u6e5eeef4vccfb509be7ad4198@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Hi All,

I installed RHEL on a blade with only one LUN and with only one controller up.
So for obvious reasons, even though I specified the option "linux
mpath" for installer, the only device available for partition was
/dev/sda/.
I letthe installaer to create default partition, that is LVM based partition.

Later, after everything goes well, I addthe second controller and then
reboot the blade, butu multipath was not configured on any of the
devices (root, boot or swap).

I modified the /etc/fstab file to mount the /boot by device id (this
was the only device that was referring to /dev/sda) and rebooted, but
still no luck.

What am I missing here? How do I configure multipath on /root.

Thanks and Regards,
Pradipmaya.
