From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: multipath
Date: Fri, 25 Mar 2005 20:31:35 +0100
Message-ID: <1111779095.7024.71.camel@zezette>
References: <200503251925.j2PJPIiG010756@smtp2.corp.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
In-Reply-To: <200503251925.j2PJPIiG010756@smtp2.corp.netapp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Igor Feoktistov <igorf@netapp.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Yes, blacklist "dm-" not "dm"

I had to touch the blacklist algo, as said in the changelog, but it
still not satisfying.

I'd like to move to a regexp-like parser.
If you are interested in this well contained project ...

I Cc: the mailing list too, as I fear the question will arise more than
once :) Please forgive the rudeness.

Regards,
cvaroqui

On ven, 2005-03-25 at 11:24 -0800, Igor Feoktistov wrote:
> Hi Christophe,
> 
> It seems I cannot backlist devnode's since 0.4.3
> I have next devnode_blacklist:
> --
> devnode_blacklist {                                                               
>         devnode c0d                                                               
>         devnode c1d                                                               
>         devnode c2d                                                               
>         devnode ub                                                                
>         devnode nbd                                                               
>         devnode fd                                                                
>         devnode hd                                                                
>         devnode md                                                                
>         devnode dm                                                                
>         devnode sr                                                                
>         devnode scd                                                               
>         devnode st                                                                
>         devnode ram                                                               
>         devnode raw                                                               
>         devnode loop                                                              
> }                                                                                
> --
> However, I'm still getting errors from multipathd like below.
> Please note I've added devname in syslog output so I can know
> which devnode it complaints about
> --
> Mar 25 11:08:09 fedora multipathd: can not get scsi strings for dm-0              
> Mar 25 11:08:09 fedora multipathd: can not get scsi strings for dm-1              
> Mar 25 11:08:09 fedora multipathd: can not get scsi strings for dm-2              
> Mar 25 11:08:09 fedora multipathd: can not get scsi strings for dm-3              
> Mar 25 11:08:09 fedora multipathd: can not get scsi strings for hdc               
> --
> Any thoughts?
> 
> Thanks,
> Igor.
-- 
christophe varoqui <christophe.varoqui@free.fr>
