From: Thanos Makatos <thanos.makatos@sunlight.io>
Subject: Re: extracting thin mappings in real time
Date: Fri, 5 Oct 2018 16:53:27 +0100
Message-ID: <CA+fs2JPZ9mFm2O0yOJun+mCX2NftrqEcGpc-9hCnbi6YVyy-Tg@mail.gmail.com>
References: <CA+fs2JN0evmnJP2yZT144bUOdxaxUydchXrZmLmFVy4F20yfAA@mail.gmail.com>
	<20181003130333.GA20800@reti>
	<CA+fs2JN0FHg_ZGawUACWbJPfCpna1fi7PAMzDem2viNZ-zSthQ@mail.gmail.com>
	<20181003144720.GC20800@reti>
	<CA+fs2JOt5oM7=v8KGdwDuq4mP=GDF4zQTYuug=Fj3QecMmWdLA@mail.gmail.com>
	<20181004125612.GA17205@reti>
	<CA+fs2JONQBrN0fqjJEBmewpLmwxNWiUn3PGpP+yQVxtLWL6ReQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CA+fs2JONQBrN0fqjJEBmewpLmwxNWiUn3PGpP+yQVxtLWL6ReQ@mail.gmail.com>
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

> Instead I gave a second thought to the solution of using dm-thin's
> public functions to access it's metadata, namely dm_thin_find_block.
> The problem is that if the mapping is not in memory I'll have to read
> it from disk, outside the critical path, and this adds complexity.
> However, since the mapping was just established it should be cached so
> it should mostly work (not being able to obtain the mapping every now
> and then is acceptable). Does this make sense?

I call dm_thin_find_block right after I've received the write
completion and if I don't set can_issue_io to 1 it _always_ fails. If
I do set it to 1 then it always succeeds but reads 20 KB from the
metadata device, even when repeatedly called. I can see that
internally it uses dm-bufio, which is supposed to some caching, no? Am
I missing something?
