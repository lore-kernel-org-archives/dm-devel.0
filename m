From: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Subject: Re: [PATCH v2 1/2] md raid0/linear: Introduce new array
 state 'broken'
Date: Wed, 21 Aug 2019 11:16:25 -0300
Message-ID: <c35cd395-fc54-24c0-1175-d3ea0ab0413d@canonical.com>
References: <20190816134059.29751-1-gpiccoli@canonical.com>
	<CAPhsuW7aGze5p9DgNAe=KakJGXTNqRZpNCtvi8nKxzS2MPXrNQ@mail.gmail.com>
	<1f16110b-b798-806f-638b-57bbbedfea49@canonical.com>
	<1725F15D-7CA2-4B8D-949A-4D8078D53AA9@fb.com>
	<4c95f76c-dfbc-150c-2950-d34521d1e39d@canonical.com>
	<8E880472-67DA-4597-AFAD-0DAFFD223620@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <8E880472-67DA-4597-AFAD-0DAFFD223620@fb.com>
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
To: Song Liu <songliubraving@fb.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Song Liu <liu.song.a23@gmail.com>, NeilBrown <neilb@suse.com>, linux-raid <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Jay Vosburgh <jay.vosburgh@canonical.com>
List-Id: dm-devel.ids

On 19/08/2019 18:57, Song Liu wrote:
> [...]
> How about we test this when we do clear_bit(Faulty..)? And maybe also in 
> add_new_disk()?
> 
> Thanks,
> Song
> 

Song, thanks for the suggestions. I've been working in the refactor, so
far it's working fine. But I cannot re-add a member to raid0/linear
without performing a full stop (with "mdadm --stop"), and in this case
md_clean() will clear the flag. Restarting array this way works fine.

If I try writing 'inactive' to array_state, I cannot reinsert the member
to the array. That said, I don't think we need to worry in clearing
MD_BROKEN for RAID0/LINEAR, and it makes things far easier.
Are you ok with that? I'll submit V3 after our discussion.

Thanks,


Guilherme
