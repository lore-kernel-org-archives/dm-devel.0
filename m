From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v2 1/2] md raid0/linear: Introduce new array
 state 'broken'
Date: Mon, 19 Aug 2019 21:57:11 +0000
Message-ID: <8E880472-67DA-4597-AFAD-0DAFFD223620@fb.com>
References: <20190816134059.29751-1-gpiccoli@canonical.com>
	<CAPhsuW7aGze5p9DgNAe=KakJGXTNqRZpNCtvi8nKxzS2MPXrNQ@mail.gmail.com>
	<1f16110b-b798-806f-638b-57bbbedfea49@canonical.com>
	<1725F15D-7CA2-4B8D-949A-4D8078D53AA9@fb.com>
	<4c95f76c-dfbc-150c-2950-d34521d1e39d@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4c95f76c-dfbc-150c-2950-d34521d1e39d@canonical.com>
Content-Language: en-US
Content-ID: <701F7D3BDA043B4FB7ECA9A65B7F182C@namprd15.prod.outlook.com>
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



> On Aug 19, 2019, at 12:11 PM, Guilherme G. Piccoli <gpiccoli@canonical.com> wrote:
> 
> On 19/08/2019 15:57, Song Liu wrote:
>> [...] 
>> 
>> I was thinking, if we can set MD_BROKEN when the device fails, we can 
>> just test MD_BROKEN in array_state_show() (instead of iterating through 
>> all devices). 
>> 
>> Would this work?
>> 
>> Thanks,
>> Song
>> 
> 
> This could work, but will require some refactors; it'll simplify the
> check for a healthy array (no need for is_missing_dev() function) but
> will complicate the criteria to clear MD_BROKEN and the detection of
> more members failing (we would stop the detection after the 1st failure
> if we only test MD_BROKEN).
> 
> We will always need to test the GENHD_FL_UP in some code path, to be
> able to show users device recovered from a failure.
> Where do you suggest to test this flag?

How about we test this when we do clear_bit(Faulty..)? And maybe also in 
add_new_disk()?

Thanks,
Song
