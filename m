From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 0/6] Various multipath-tools patches
Date: Tue, 6 Mar 2018 09:25:18 -0600
Message-ID: <20180306152518.GO14513@octiron.msp.redhat.com>
References: <20180301192935.14643-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180301192935.14643-1-bart.vanassche@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Mar 01, 2018 at 11:29:29AM -0800, Bart Van Assche wrote:
> Hello Christophe,
> 
> This series contains the following patches:
> - Four patches address Coverity complaints.
> - One patch makes a function argument const.
> - One patch addresses a bug that I discovered while inspecting the multipath
>   command line tool output.
> 
> Please consider these patches for the multipath-tools project.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

For the set. Buy I agree with Martin that we should fold some of these
into his already posted patches.

-Ben

> 
> Thanks,
> 
> Bart.
> 
> Bart Van Assche (6):
>   multipathd/main.c: Fix indentation
>   libmultipath, alloc_path_with_pathinfo(): Ensure that pp->wwid is
>     '\0'-terminated
>   libmultipath, alloc_path_with_pathinfo(): Declare third argument const
>   kpartx: Improve reliability of find_loop_by_file()
>   libmultipath: Fix sgio_get_vpd()
>   Introduce the ibmultipath/unaligned.h header file
> 
>  kpartx/lopart.c                       |  7 ++++---
>  libmpathpersist/mpath_pr_ioctl.c      |  8 ++++----
>  libmultipath/checkers/hp_sw.c         |  4 ++--
>  libmultipath/discovery.c              | 22 +++++++++++---------
>  libmultipath/discovery.h              |  2 +-
>  libmultipath/prioritizers/alua_rtpg.c | 13 ++++++------
>  libmultipath/prioritizers/alua_spc3.h | 35 ++------------------------------
>  libmultipath/prioritizers/ontap.c     |  4 ++--
>  libmultipath/unaligned.h              | 38 +++++++++++++++++++++++++++++++++++
>  multipathd/main.c                     |  4 ++--
>  10 files changed, 74 insertions(+), 63 deletions(-)
>  create mode 100644 libmultipath/unaligned.h
> 
> -- 
> 2.16.2
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
