From: Thanos Makatos <thanos.makatos@sunlight.io>
Subject: Re: extracting thin mappings in real time
Date: Fri, 5 Oct 2018 12:33:21 +0100
Message-ID: <CA+fs2JONQBrN0fqjJEBmewpLmwxNWiUn3PGpP+yQVxtLWL6ReQ@mail.gmail.com>
References: <CA+fs2JN0evmnJP2yZT144bUOdxaxUydchXrZmLmFVy4F20yfAA@mail.gmail.com>
	<20181003130333.GA20800@reti>
	<CA+fs2JN0FHg_ZGawUACWbJPfCpna1fi7PAMzDem2viNZ-zSthQ@mail.gmail.com>
	<20181003144720.GC20800@reti>
	<CA+fs2JOt5oM7=v8KGdwDuq4mP=GDF4zQTYuug=Fj3QecMmWdLA@mail.gmail.com>
	<20181004125612.GA17205@reti>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181004125612.GA17205@reti>
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

On Thu, 4 Oct 2018 at 13:56, Joe Thornber <thornber@redhat.com> wrote:
>
> On Wed, Oct 03, 2018 at 04:47:41PM +0100, Thanos Makatos wrote:
> > poo metadata object can return this information? I've started looking
> > at  thin_bio_map(), is this the best place to start?
>
> See thin-metadata.h
>
> - Joe

I started looking at piggybacking the mapping in bio->bi_pivate in
provision_block and it looks ugly. First, I'll have to introduce a new
bio flag specifically for this reason: whenever dm-thin sees this it
should store the mapping in the bio->bi_private. Second, the bio
passed to dm-thin is cloned so I'll have to find the original bio
(this requires making struct dm_io public). And third, the original
bio can be split to multiple cloned bios so the structure in
bio->bi_pivate should accomodate this.

Instead I gave a second thought to the solution of using dm-thin's
public functions to access it's metadata, namely dm_thin_find_block.
The problem is that if the mapping is not in memory I'll have to read
it from disk, outside the critical path, and this adds complexity.
However, since the mapping was just established it should be cached so
it should mostly work (not being able to obtain the mapping every now
and then is acceptable). Does this make sense?
