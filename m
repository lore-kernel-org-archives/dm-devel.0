From: Dave Wysochanski <dwysocha@redhat.com>
Subject: Re: Problem with multipath and kernel 2.6.18-92.el5
Date: Thu, 29 May 2008 16:04:54 -0400
Message-ID: <1212091494.4485.6.camel@localhost.localdomain>
References: <483EA571.5010009@univ-tln.fr>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <483EA571.5010009@univ-tln.fr>
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

On Thu, 2008-05-29 at 14:45 +0200, Twardy Sandrine wrote:
> Hello,
> 
> I have update my server to kernel 2.6.18-92.el5, and multipath not work 
> because a module dm_hp_sw is automatically load. But this module seem 
> don't work for my EVA 5000 HSV110.
> 
> i would like not load this module, but the command multipath -v 3 load 
> this module why ? Can I dont load this module ?
> 
> Thanks a lot for your responses
> 


What are the vendor and product strings? (cat /sys/block/<devicename>/device/vendor and
/sys/block/<devicename>/device/model).

Could be there's an incorrect entry in hwtable.c causing the module to load incorrectly.

You should be able to override an incorrect entry from hwtable.c by putting a new entry
into /etc/multipath.conf for your device.  To specify a null hwhandler, use something like:
device {
                vendor                  "COMPAQ"
                product                 "MSA1000 VOLUME"
                path_grouping_policy    group_by_prio
                hardware_handler        "0"
                path_checker            hp_sw
                features                "1 queue_if_no_path"
                prio_callout            "/sbin/mpath_prio_hp_sw /dev/%n"
                failback                immediate
        }
