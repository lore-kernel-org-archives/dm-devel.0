From: shankha <sbanerjee@cloudistics.com>
Subject: Re: artificially break/corrupt thin pool
Date: Wed, 15 Mar 2017 19:42:31 -0400
Message-ID: <73b4c3cd-371d-0ea5-978f-02403892769a@cloudistics.com>
References: <CAM2wQBs3SHUvUCmnqjs9YiuAaAg3R0vA59BEZ6-8RqZT5B7QNA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAM2wQBs3SHUvUCmnqjs9YiuAaAg3R0vA59BEZ6-8RqZT5B7QNA@mail.gmail.com>
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

With older kernels (3.10.0.327) I had seen the error message when one 
tries to create lot of snapshots (100's), perform writes on those 
snapshots and running thin tools like thin_dump or thin_delta.

I haven't seen those with 3.10.0-514.


On 03/14/2017 08:40 AM, Thanos Makatos wrote:
> >From time to time I get the error "Check of pool foo/bar failed
> (status:1). Manual repair required!" and I'm writing a script that
> tries to repair the thin pool and re-activate it (lvconvert --repair
> foor/bar && lvchange -ay foo/bar).
>
> However it's hard to test as I do not usually have a broken thin pool
> at hand. Is there some simple way to break the thin pool and render it
> "repairable"?
>
