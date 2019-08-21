From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v2 1/2] md raid0/linear: Introduce new array
 state 'broken'
Date: Wed, 21 Aug 2019 18:06:10 +0000
Message-ID: <F0E83794-C5CA-4E4D-A649-21DC9E2957B8@fb.com>
References: <20190816134059.29751-1-gpiccoli@canonical.com>
	<CAPhsuW7aGze5p9DgNAe=KakJGXTNqRZpNCtvi8nKxzS2MPXrNQ@mail.gmail.com>
	<1f16110b-b798-806f-638b-57bbbedfea49@canonical.com>
	<1725F15D-7CA2-4B8D-949A-4D8078D53AA9@fb.com>
	<4c95f76c-dfbc-150c-2950-d34521d1e39d@canonical.com>
	<8E880472-67DA-4597-AFAD-0DAFFD223620@fb.com>
	<c35cd395-fc54-24c0-1175-d3ea0ab0413d@canonical.com>
	<B7287054-70AC-47A8-BA5A-4D3D7C3F689F@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <B7287054-70AC-47A8-BA5A-4D3D7C3F689F@fb.com>
Content-Language: en-US
Content-ID: <FE8D60056E4BE34890A497A6C8603777@namprd15.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Song Liu <liu.song.a23@gmail.com>, NeilBrown <neilb@suse.com>, linux-raid <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Jay Vosburgh <jay.vosburgh@canonical.com>
List-Id: dm-devel.ids



> On Aug 21, 2019, at 9:14 AM, Song Liu <songliubraving@fb.com> wrote:
> 
> 
> 
>> On Aug 21, 2019, at 7:16 AM, Guilherme G. Piccoli <gpiccoli@canonical.com> wrote:
>> 
>> On 19/08/2019 18:57, Song Liu wrote:
>>> [...]
>>> How about we test this when we do clear_bit(Faulty..)? And maybe also in 
>>> add_new_disk()?
>>> 
>>> Thanks,
>>> Song
>>> 
>> 
>> Song, thanks for the suggestions. I've been working in the refactor, so
>> far it's working fine. But I cannot re-add a member to raid0/linear
>> without performing a full stop (with "mdadm --stop"), and in this case
>> md_clean() will clear the flag. Restarting array this way works fine.
>> 
>> If I try writing 'inactive' to array_state, I cannot reinsert the member
>> to the array. That said, I don't think we need to worry in clearing
>> MD_BROKEN for RAID0/LINEAR, and it makes things far easier.
>> Are you ok with that? I'll submit V3 after our discussion.
>> 
> 
> What do you mean by "not clear MD_BROKEN"? Do you mean we need to restart
> the array? 
> 
> IOW, the following won't work:
> 
>  mdadm --fail /dev/md0 /dev/sdx
>  mdadm --remove /dev/md0 /dev/sdx
>  mdadm --add /dev/md0 /dev/sdx
> 
> And we need the following instead:
> 
>  mdadm --fail /dev/md0 /dev/sdx
>  mdadm --remove /dev/md0 /dev/sdx
>  mdadm --stop /dev/md0 /dev/sdx
>  mdadm --add /dev/md0 /dev/sdx
>  mdadm --run /dev/md0 /dev/sdx

Btw, the MD_BROKEN patch conflicts with one of Neil's patches. Please 
rebase your work on top of

https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git/tree/?h=md-next

Thanks,
Song
