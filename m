From: Brian Long <brilong@cisco.com>
Subject: Re: LVM2, RHEL 4 update 2: can't remove logical volume
Date: Thu, 27 Oct 2005 07:41:04 -0400
Message-ID: <1130413264.4047.13.camel@brilong-lnx>
References: <OF29A33E0B.95E7850F-ONC12570A7.002EDB85-C12570A7.0031344E@de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <OF29A33E0B.95E7850F-ONC12570A7.002EDB85-C12570A7.0031344E@de.ibm.com>
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

On Thu, 2005-10-27 at 10:58 +0200, Stefan Bader wrote:
> We got something similar here. Try to change the filter rules to exclude 
> the
> volume group devices. What you want is the devices created by the
> multipath-tools included but not the devices created by lvm2.
> Otherwise the tools will have the lv open at the time they should be
> removed.
> 
> Stefan Bader

Stefan,

Could you post your filter example so Phil and I can integrate it into
our lvm.conf?  Thanks!

/Brian/

-- 
       Brian Long                      |         |           |
       IT Data Center Systems          |       .|||.       .|||.
       Cisco Linux Developer           |   ..:|||||||:...:|||||||:..
       Phone: (919) 392-7363           |   C i s c o   S y s t e m s
