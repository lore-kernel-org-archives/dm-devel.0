From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: multipath-tools Makefile
Date: Mon, 18 Jun 2007 17:57:59 -0700
Message-ID: <1182214679.5301.88.camel@linuxchandra>
References: <20070618225947.26450.qmail@sourceware.org>
Reply-To: sekharan@us.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070618225947.26450.qmail@sourceware.org>
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
Cc: dm-cvs@sourceware.org, Christophe Varoqui <christophe.varoqui@free.fr>
List-Id: dm-devel.ids

Hi,

Sorry about the late response. I just realized that pp_rdac has been
added to the multipath tree.

pp_rdac is not needed to support lsi-rdac devices. pp_tpc performs
equally good. I repeated my tests with pp_tpc and they did work well.

Thanks,

chandra
On Mon, 2007-06-18 at 22:59 +0000, bmarzins@sourceware.org wrote:
> CVSROOT:	/cvs/dm
> Module name:	multipath-tools
> Branch: 	RHEL5_FC6
> Changes by:	bmarzins@sourceware.org	2007-06-18 22:59:47
> 
> Modified files:
> 	.              : Makefile 
> 
> Log message:
> 	added missing pp_rdac directory to Makefile
> 
> Patches:
> http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/Makefile.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.7.2.1&r2=1.7.2.2
> 
> --- multipath-tools/Makefile	2007/06/18 17:37:17	1.7.2.1
> +++ multipath-tools/Makefile	2007/06/18 22:59:47	1.7.2.2
> @@ -21,11 +21,11 @@
>  export KRNLOBJ
>  BUILDDIRS = multipath multipathd kpartx cciss_id path_priority/pp_alua \
>  	    path_priority/pp_emc path_priority/pp_hds_modular \
> -	    path_priority/pp_netapp path_priority/pp_tpc
> +	    path_priority/pp_netapp path_priority/pp_rdac path_priority/pp_tpc
> 
>  ALLDIRS = multipath multipathd kpartx cciss_id path_priority/pp_alua \
>  	  path_priority/pp_emc path_priority/pp_hds_modular \
> -	  path_priority/pp_netapp path_priority/pp_tpc \
> +	  path_priority/pp_netapp path_priority/pp_rdac path_priority/pp_tpc \
>  	  libmultipath libcheckers
> 
>  VERSION = $(shell basename ${PWD} | cut -d'-' -f3)
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
-- 

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------
