From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Subject: Re: IO controller Mini-Summit 2009
Date: Thu, 15 Oct 2009 10:42:19 +0900
Message-ID: <4AD67DFB.60402@oss.ntt.co.jp>
References: <20091014.212444.179938286.ryov@valinux.co.jp>
	<20091014175521.GG3528@redhat.com> <4AD66F28.9030607@oss.ntt.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4AD66F28.9030607@oss.ntt.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: =?ISO-8859-1?Q?Fernando_Luis_V=E1zquez_Cao?= <fernando@oss.ntt.co.jp>
Cc: xen-devel@lists.xensource.com, Gui Jianfeng <guijianfeng@cn.fujitsu.com>, containers@lists.linux-foundation.org, Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, virtualization@lists.linux-foundation.org, dm-devel@redhat.com, Dong-Jae Kang <baramsori72@gmail.com>, Nauman Rafique <nauman@google.com>, Akio Takebe <takebe_akio@jp.fujitsu.com>, Jens Axboe <jens.axboe@oracle.com>, Munehiro Ikeda <m-ikeda@ds.jp.nec.com>, Vivek Goyal <vgoyal@redhat.com>, Balbir Singh <balbir@linux.vnet.ibm.com>
List-Id: dm-devel.ids

Hi all,

As Fernando said below, I will be glad if I can help you by taking
notes of the mini summit. I would also be glad if someone helps me
take notes.


Tsuruta-san, thank you for summarizing the topics. It looks good!
The only thing I am worrying about is whether we can summarize our
discussions for 5-6 minutes of presentation.

I would be happy if we all have it in mind that we can send our
message to maintainers, including Ted Tso, by sending our summary.
So before starting the discussion, how about taking some time to
talk about which topic we want to include in the summary.


IMHO,
 >>> - The place where IO controller should be implemented
is the most important, basic, topic, and other things should be
summarized so as to explain why we think the place, e.g. block layer,
VFS layer, common layer, is better for implementing io controllers.

It would also be better if we can answer to the comments we have
already received from maintainers, e.g. Andrew, Jens.


Thanks,
Takuya Yoshikawa




Fernando Luis V=E1zquez Cao wrote:
> Hi Vivek,
>=20
> Thank you for CCing me.
>=20
> I just wanted to let you know that Ted Tso was kind enough to let
> us give a readout for the mini-summit at the kernel summit.
>=20
> There will be other mini-summits sharing 50 minutes so we need to
> keep each mini-summit readout to 5-6 minutes of presentation and
> 4-5 minutes of questions/discussions.
>=20
> Yoshikawa-san and myself were planning to take notes of the
> mini-summit, but it would be great if you could share yours.  The
> idea is to use those to prepare a brief mini-summit report (4-5
> slides) that we can show at the kernel summit.
>=20
> Later in the day, after the mini-summit, we would be sending a
> draft version of the slides to the relevant mailing lists for you
> to review. Since the mini-summit readouts will take place on
> Monday I would appreciate it if you could comment on them before
> Sunday night the latest.
>=20
> Thanks,
>=20
> Fernando
>=20
> Vivek Goyal wrote:
>> On Wed, Oct 14, 2009 at 09:24:44PM +0900, Ryo Tsuruta wrote:
>>> Hello,
>>>
>>
>> Hi Ryo,
>>
>> CCing people who are planning to attend the mini summit either in pers=
on
>> or phone. (As per your list on io mini summit wiki page). Not sure if
>> everybody is scanning mailing list for update on mini summit.
>>
>> I am checking out wiki page for more information like Venue. It says t=
he
>> venue is linux foundation office Japan. Hopefully there is no change i=
n
>> that information.
>>
>> What are the conference call details for the people who might want to=20
>> join
>> in over phone? Could not find those. Are you yet to post these?
>>
>> Thanks
>> Vivek
>>
>>> I have summarized the topics for the IO controller mini-summit and
>>> written the ideas seen in the mailing list.
>>>
>>> - The place where IO controller should be implemented
>>>   - Block layer in conjunction with the IO scheduler
>>>   - Common layer right above the IO scheduler
>>>   - CFQ enhancement.
>>>   - Both block and common layer, users can select whichever controlle=
r
>>>     they want.
>>>   - VFS layer
>>>
>>> - What kind of bandwidth control policies are needed?
>>>   - Proportional weight
>>>   - Enforcing upper limit
>>>   - Minimum bandwidth guarantee
>>>
>>> - How to handle buffered writes?
>>>   - Add dirt-ratio in the memory controller
>>>   - Add bufferred-write-cgroup to track buffered writebacks
>>>   - A per group per bdi pdflush threads
>>>
>>> - Who should be charged for swap activity?
>>>   - who requests a page.
>>>   - who has a page.
>>>   - All swap activities are charged to the root group.
>>>
>>> And I would also like to discuss about the followings.
>>>
>>> - Extensions of struct bio
>>>   - Make a bio point to the io_context of a process which creates the
>>>     I/O request. This allows to pass the IO scheduling class and
>>>     priority information to IO controller even if the IO is submitted
>>>     by another process which does not create the request, such as a
>>>     worker thread.
>>>   - Add a new flag to struct bio to identify the bio as urgent. This
>>>     gives IO controller a chance to handle the bio as high
>>>     priority. This flag should be set if the bio is created for the
>>>     page-out operation.
>>> - Common test methods to verify the functionality of IO controller.
>>>
>>> Please give me comments and suggestions. I may be missing or
>>> misunderstanding something.
>>>
>>> Thanks,
>>> Ryo Tsuruta
>>> --=20
>>> To unsubscribe from this list: send the line "unsubscribe=20
>>> linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>=20
>=20
