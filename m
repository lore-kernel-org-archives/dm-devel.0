From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 7/7] dm-mpath: Fix a race condition in
	__multipath_map()
Date: Tue, 15 Nov 2016 20:50:21 -0500
Message-ID: <20161116015021.GA19469@redhat.com>
References: <e83f8718-9e73-5544-3bcc-4d9851b90ba1@sandisk.com>
	<81bc399e-df90-099d-1b25-bdb0fda3f27c@sandisk.com>
	<20161116003720.GA19059@redhat.com>
	<8af6b1c0-3513-8a13-5ebb-8bdf90bf43e0@sandisk.com>
	<20161116010117.GE19059@redhat.com>
	<4411f9ca-da76-d222-a2ee-3edc59c82266@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4411f9ca-da76-d222-a2ee-3edc59c82266@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Nov 15 2016 at  8:08pm -0500,
Bart Van Assche <bart.vanassche@sandisk.com> wrote:

> On 11/15/2016 05:01 PM, Mike Snitzer wrote:
> >On Tue, Nov 15 2016 at  7:40pm -0500,
> >Bart Van Assche <bart.vanassche@sandisk.com> wrote:
> >>Are you aware that dm_table_determine_type() sets "all_blk_mq" to
> >>false if there are no paths, even if the dm device is in blk-mq
> >>mode?
> >
> >That shouldn't matter.  Once the type is established, it is used to
> >initialize the DM device's request_queue, the type cannot change across
> >different table loads.
> 
> For a single queue dm device, what prevents a user from removing all
> single queue paths and to add one or more blk-mq paths? I think this
> will cause dm_table_determine_type() to change the table type.

A new table is created for every table load (any time a multipath device
is loaded into the kernel).  The DM core disallows a table with a
different type to load.  It will be rejected within an error.

See dm-ioctl.c:table_load()
