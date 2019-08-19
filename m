From: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Subject: Re: [PATCH v2 1/2] md raid0/linear: Introduce new array
 state 'broken'
Date: Mon, 19 Aug 2019 16:11:19 -0300
Message-ID: <4c95f76c-dfbc-150c-2950-d34521d1e39d@canonical.com>
References: <20190816134059.29751-1-gpiccoli@canonical.com>
	<CAPhsuW7aGze5p9DgNAe=KakJGXTNqRZpNCtvi8nKxzS2MPXrNQ@mail.gmail.com>
	<1f16110b-b798-806f-638b-57bbbedfea49@canonical.com>
	<1725F15D-7CA2-4B8D-949A-4D8078D53AA9@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1725F15D-7CA2-4B8D-949A-4D8078D53AA9@fb.com>
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

On 19/08/2019 15:57, Song Liu wrote:
>[...] 
> 
> I was thinking, if we can set MD_BROKEN when the device fails, we can 
> just test MD_BROKEN in array_state_show() (instead of iterating through 
> all devices). 
> 
> Would this work?
> 
> Thanks,
> Song
> 

This could work, but will require some refactors; it'll simplify the
check for a healthy array (no need for is_missing_dev() function) but
will complicate the criteria to clear MD_BROKEN and the detection of
more members failing (we would stop the detection after the 1st failure
if we only test MD_BROKEN).

We will always need to test the GENHD_FL_UP in some code path, to be
able to show users device recovered from a failure.
Where do you suggest to test this flag?

Thanks,


Guilherme
