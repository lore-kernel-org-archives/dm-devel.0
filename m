From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: Reducing amount of logmessages openiscsi/multipath
	[with md3000i]
Date: Tue, 19 Aug 2008 17:12:21 -0400
Message-ID: <20080819211221.GC22302@mars.virtualiron.com>
References: <005b01c901fd$37683660$a638a320$@net>
	<48AB00C5.8050604@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <48AB00C5.8050604@cs.wisc.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: open-iscsi@googlegroups.com
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Aug 19, 2008 at 12:20:05PM -0500, Mike Christie wrote:
> 
> Kees Hoekzema wrote:
> > Hello List,
> 
> I am adding the dm-devel list.
> 
> I think you want different settings in your multipath conf. For example 
> it looks like you are using directio to test paths and you want TUR or 
> the md3000i specific one which does not cause IO errors to passive paths.

He wants the RDAC hw handler and its path checker (rdac). The MD3000i is an
LSI re-branded box and is the same as the IBM DS3300.

> 
> You also want to make sure that you are using the md3000i hw handler or 
> scsh_dh_module if you are not already. The dm-devel guys can help you out.

Here is the multipath.conf he should be using for MD3000i (or for the DS3300
but will need to modify the vendor/model entry)

        # Note: The same as the IBM DS3300
        #
        device {
                vendor                  "DELL"
                product                 "MD3000i"
                product_blacklist       "Universal Xport"
                features                "1 queue_if_no_path"
                path_grouping_policy    group_by_prio
                hardware_handler        "1 rdac"
                path_checker            rdac
                prio                    "rdac"
                failback                immediate
        }
