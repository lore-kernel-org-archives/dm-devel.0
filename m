From: Dave Wysochanski <dave.wysochanski@redhat.com>
Subject: Re: multipath.conf don't being read
Date: Sun, 26 Nov 2006 23:45:04 -0500
Message-ID: <1164602704.4343.19.camel@linux-cxyg.rtp.netapp.com>
References: <39fdf1c70611261318t2f7aba20j4f319d4793cfd87d@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <39fdf1c70611261318t2f7aba20j4f319d4793cfd87d@mail.gmail.com>
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

On Sun, 2006-11-26 at 22:18 +0100, Claudio Tassini wrote:
> Hi all
> 
> I'm trying to understand how dm works on a RHEL 4u4, ( and RHCS and
> GFS too). I have two QLC HBAs connected to a Sun Storage 3510 via a
> couple of SANBOX2 switches. Initially I uncommented all the entries in
> the configuration file to make some test and I manage to discover the
> three luns which where recognized correctly whit their path: 
> 

It is most likely because there is an entry in the multipath code for
your array.  From what you say I'm guessing this is probably it (from
libmultipath/hwtable.c):
	r += store_hwe(hw, "SUN", "StorEdge 3510", MULTIBUS, DEFAULT_GETUID);

If you want to override the code setting, you have to put a specific
"device" section into /etc/multipath.conf, e.g.
devices {

       device {
               vendor                  "SUN"
               product                 "StorEdge 3510"
               path_grouping_policy    failover
               getuid_callout          "/sbin/scsi_id -g -u -s"
       }
}
