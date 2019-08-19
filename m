From: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Subject: Re: [PATCH v2 1/2] md raid0/linear: Introduce new array
 state 'broken'
Date: Mon, 19 Aug 2019 15:30:46 -0300
Message-ID: <1f16110b-b798-806f-638b-57bbbedfea49@canonical.com>
References: <20190816134059.29751-1-gpiccoli@canonical.com>
	<CAPhsuW7aGze5p9DgNAe=KakJGXTNqRZpNCtvi8nKxzS2MPXrNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAPhsuW7aGze5p9DgNAe=KakJGXTNqRZpNCtvi8nKxzS2MPXrNQ@mail.gmail.com>
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
To: Song Liu <liu.song.a23@gmail.com>
Cc: linux-block@vger.kernel.org, Song Liu <songliubraving@fb.com>, NeilBrown <neilb@suse.com>, linux-raid <linux-raid@vger.kernel.org>, dm-devel@redhat.com, Jay Vosburgh <jay.vosburgh@canonical.com>
List-Id: dm-devel.ids

On 19/08/2019 15:10, Song Liu wrote:
> [...]
> 
> If we merge this with the MD_BROKEN patch, would the code look simpler?
> 
> Thanks,
> Song
> 

Hi Song, I don't believe it changes the complexity/"appearance" of the
code. Both patches are "relatives" in the ideas' realm, but their code
is different in nature. My goal in splitting them was to make more
bisect-able changes.

But feel free to merge them in a single patch or let me know if you
prefer that way and I can do it.

There's also a chance I haven't understood your statement/question
correctly heh - if that's the case, please clarify me!
Cheers,

Guilherme
