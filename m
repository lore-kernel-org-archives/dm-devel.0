From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: dm-writeboost: An idea of adding read-caching
Date: Sat, 06 Dec 2014 10:42:56 +0900
Message-ID: <54825F20.7060206@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: gregkh@linuxfoundation.org, masami.hiramatsu@gmail.com, snitzer@redhat.com
List-Id: dm-devel.ids

Hi,

Let me share my idea of implementing read-caching for Writeboost, my log-structured SSD-caching driver.

This would be the next biggest improvement that I want to work in staging.

# Background
As of now, Writeboost provides only write-caching. This means it never stage data from HDD to SSD. Why I do this way is the page cache is sufficient in most cases for this purpose and stacking another read-caching target will compliment if page cache is not large enough for the workload.

In the discussion below (sorry to dig up the old thread), Mike said a target should provide both write/read caching because stacking targets isn't simple in practice while it is so in concept.

> This idea that a single target cannot provide meaningful caching for
> both reads and writes is really unwelcome.  Conceptually stacking is
> simple, but in practice the management layers that need to configure
> these stacks is fairly cumbersome.
https://www.redhat.com/archives/dm-devel/2014-January/msg00078.html

At that moment, I didn't consider read-caching can be implemented in Writeboost simply but I came up with a idea of implementing it these days.

# Idea
The idea is, conceptually, resending the read data (from HDD) to itself as "fake" write request.
As a result, writes and reads will be put into a log and written to the cache device sequentially.

There are few requirements that read-caching should achieve:
- Staged data shouldn't be written back (because they are clean) for performance but this isn't a logical bug.
- Clean data on the cache device shouldn't be discarded after reboot.
- Too big sequential (e.g. >128KB) read shouldn't be staged. This is called threshold.

The implementation basic would be:
1. Store read data to buffer in endio (does the bio has the read data while in endio?)
2. If the buffer is full, wake up a worker to submit the data as "fake" write requests to itself.
   (but it doesn't really submit bio through generic_make_request but only pass through the internal write path)

Threshold can be implemented by having a pointer on the buffer to treat it like a stack.
(If the series of data acked are longer sequential than threshold, retard the pointer the cancelled distance)

I think the interface change would be only adding a tunable like "read_cache_threshold (int)" which means
read caching is disabled when the value is zero and
the non-zero value represents the threshold.

It sounds easy but there is one thing that really annoys me. That is, a problem of possibly
resending stale data. I think I need some data structure to add to avoid this problem but I am not sure what it would look like.

Thank you for reading,

- Akira
