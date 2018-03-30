From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: Revert "dm mpath: remove unnecessary NVMe branching
 in favor of scsi_dh checks"
Date: Fri, 30 Mar 2018 17:04:08 +0000
Message-ID: <733dbda8db10738e3d374e146b0833d895564f9d.camel@wdc.com>
References: <20180312202808.3556-1-bart.vanassche@wdc.com>
	<20180312212314.GA30763@redhat.com> <1520890358.3469.68.camel@wdc.com>
	<20180313152551.GA2785@redhat.com> <20180313163135.GB2785@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180313163135.GB2785@redhat.com>
Content-Language: en-US
Content-ID: <5AB37D69795E8042BD07C6786E3D655A@namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, 2018-03-13 at 12:31 -0400, Mike Snitzer wrote:
> But now I cannot get the test to run:
> 
> # srp-test/run_tests -c -d -r 10 -t 02-mq
> [ ... ]
> /dev/disk/by-id/dm-uuid-mpath-3600140572616d6469736b31000000000: not found
> Test srp-test/tests/02-mq failed

Hello Mike,

The bug that caused this failure has been fixed and is in linux-next. The
srp-test software runs fine on my setup against linux-next. See also
https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git/commit/?h=for-next&id=b470c154c600e427592df5237596ce0f33ce7d9f

Bart.
