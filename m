From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: Compiling multipath-tools
Date: Wed, 25 May 2011 13:19:02 +0200
Message-ID: <1306322342.2290.26.camel@lapoo.opensvc.com>
References: <94282a07-09ae-454a-ad3d-d6ccae4e5d1e@office.splatnix.net>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <94282a07-09ae-454a-ad3d-d6ccae4e5d1e@office.splatnix.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On mer., 2011-05-25 at 11:56 +0100, --[ UxBoD ]-- wrote:
> Hi, I am trying to use kernel 2.6.37.6 and build the latest version of multipath-tools. I have downloaded the source from http://christophe.varoqui.free.fr/multipath-tools/multipath-tools-0.4.9.tar.bz2 which compiles fine; though when I try and create the RPM I see: 
> 
Please try to fix the files section of the spec file and propose a
patch.

Thanks.

> Processing files: multipath-tools-__VERSION__-1 
> error: File not found by glob: /var/tmp/multipath-tools-__VERSION__-1-buildroot/lib/multipath/*.so 
> Checking for unpackaged file(s): /usr/lib/rpm/check-files /var/tmp/multipath-tools-__VERSION__-1-buildroot 
> error: Installed (but unpackaged) file(s) found: 
> /lib64/libmultipath.so.0 
> /lib64/multipath/libcheckcciss_tur.so 
> /lib64/multipath/libcheckdirectio.so 
> /lib64/multipath/libcheckemc_clariion.so 
> /lib64/multipath/libcheckhp_sw.so 
> /lib64/multipath/libcheckrdac.so 
> /lib64/multipath/libcheckreadsector0.so 
> /lib64/multipath/libchecktur.so 
> /lib64/multipath/libprioalua.so 
> /lib64/multipath/libprioconst.so 
> /lib64/multipath/libpriodatacore.so 
> /lib64/multipath/libprioemc.so 
> /lib64/multipath/libpriohds.so 
> /lib64/multipath/libpriohp_sw.so 
> /lib64/multipath/libprionetapp.so 
> /lib64/multipath/libpriorandom.so 
> /lib64/multipath/libpriordac.so 
> 
> What I am attempting to achieve is the ability to use a newer kernel with the latest multipath and open-iscsi toolsets. 
> 
> Any advice would be gratefully appreciated. 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
