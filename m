From: Mike <mikeandmore@gmail.com>
Subject: Re: [PATCH] dm-bufio: avoid a possible __vmalloc deadlock
Date: Tue, 16 Apr 2013 18:24:31 -0400
Message-ID: <CAMyCBXdwktoTb8GzameJYX-jxG80HTV7XdWZeKnEK9nQCZANSA@mail.gmail.com>
References: <Pine.LNX.4.64.1304051547370.18568@file.rdu.redhat.com>
	<20130408100006.GB21248@debian>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20130408100006.GB21248@debian>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, Mike <mikeandmore@gmail.com>
List-Id: dm-devel.ids

Hi

Sorry for my late catch up. Yes, there is a usage on dm_bufio_client_create()

struct dm_buffer *b = alloc_buffer(c, GFP_KERNEL);

Since there is no __GFP_NORETRY, alloc_buffer will fallback to
vmalloc. Also, I suspect here we'd better use GFP_NOIO &
__GFP_NORETRY?

Thanks
Mike


On Mon, Apr 8, 2013 at 6:00 AM, Joe Thornber <thornber@redhat.com> wrote:
> On Fri, Apr 05, 2013 at 03:57:50PM -0400, Mikulas Patocka wrote:
>> Hi
>>
>> This patch avoids a possible deadlock in dm-bufio. (it could happen only
>> with large block size, at most PAGE_SIZE << MAX_ORDER (typically 8MiB).
>
> Does anything currently use such large block sizes? (dm-thin and
> dm-cache stick to 4k blocks).
>
> - Joe
