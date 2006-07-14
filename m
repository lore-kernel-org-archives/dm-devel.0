From: "Bruen, Mark" <mbruen@trilegiant.com>
Subject: Trying to blacklist a USB memory stick
Date: Fri, 14 Jul 2006 10:38:33 -0400
Message-ID: <44B7AC69.20100@trilegiant.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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

I'm trying to blacklist a USB memory stick in /etc/multipath.conf. The 
output of multipath -v4:
===== path sdar =====
bus = 1
dev_t = 66:176
size = 126976
vendor =        
product = USB DISK 2.0   
rev = 1.16
h:b:t:l = 3:0:0:0
tgt_node_name =
failed to open /dev/sdar

I've tried this with the "h:b:t:l" alone and with the "product" alone 
(neither work):

devnode_blacklist {
#   devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st|sda|sdb|hdc)[0-9]*"
    devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st|hdc)[0-9]*"
    devnode "sda "
    devnode "sdb "
    wwid 350002ac0001302c6
    wwid 350002ac0002502c6
    device {
        h:b:t:l = 3:0:0:0
        product "USB DISK 2.0"
    }
}

Any ideas? Thanks.
-Mark
