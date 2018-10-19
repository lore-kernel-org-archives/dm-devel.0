From: Milan Broz <gmazyland@gmail.com>
Subject: Re: LUKS2 - RAID0 - NVME : alignment issue
Date: Fri, 19 Oct 2018 08:43:21 +0200
Message-ID: <e291e3f1-b1c4-f560-c30f-40f21e4e48c5@gmail.com>
References: <CAHzw6onNd8JskiB75PzFd4Zo45dP4fx3emoHFz8eTNkTV2+7+A@mail.gmail.com>
	<20181018184312.GA6643@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181018184312.GA6643@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, laurent cop <laurent.cop@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On 18/10/2018 20:43, Mike Snitzer wrote:
> On Fri, Oct 12 2018 at  7:56am -0400,
> laurent cop <laurent.cop@gmail.com> wrote:
> 
>>    2) Is it normal to have low performances while writing with dd. I was
>>    using LUKS previously and I got only one dev mapper. Now I got 2. Does it
>>    have a big impact on performances?
> 
> This last question really makes me wonder: did you intend to enable the
> use of dm-integrity?

If you use an authenticated encryption in LUKS2, it must use dm-integrity as a backend,
so you get two stacked devices. (Authentication tag and random IV must be stored together
with every sector, here dm-integrity just provides a space for it, it does not
calculate anything, all is up to dm-crypt.)


m.
