From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Subject: Re: dm-integrity: integrity protection device-mapper
	target
Date: Mon, 21 Jan 2013 12:38:34 +0200
Message-ID: <CALLzPKbgQkbpVw4xZyfKNCaJ2H-fLaX59OxUWzJ7=DY_VO319g@mail.gmail.com>
References: <Pine.LNX.4.64.1301151955280.7468@file.rdu.redhat.com>
	<CALLzPKZVo3ng=Hz4cg0qrw0nDYsPjKy5AR=AJtMg+3PU=epz1w@mail.gmail.com>
	<20130118231633.GM27585@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20130118231633.GM27585@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>, Mikulas Patocka <mpatocka@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, dm-devel@redhat.com, alan.cox@intel.com, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Sat, Jan 19, 2013 at 1:16 AM, Alasdair G Kergon <agk@redhat.com> wrote:
> On Fri, Jan 18, 2013 at 11:43:34PM +0200, Kasatkin, Dmitry wrote:
>> This patch I sent out has one missing feature what I have not pushed yet.
>> In the case of non-matching blocks, it just zeros blocks and returns
>> no error (zero-on-mismatch).
>> Writing to the block replaces the hmac.
>> It works quite nicely. mkfs and fsck is able to read and write/fix the
>> filesystem.
>> In normal environment, if fsck crashes, it might corrupt file system
>> in the same way.
>> zero-on-mismatch makes block device still accessible/fixable for fsck.
>
> I'm afraid I don't buy that.
>
> We can hardly call this "integrity" if it's designed to lose some of
> your data when the machine crashes - and worse - it doesn't tell you
> what you lost, but just gives you blocks of zeroes instead!
>
> I think a redesign is needed before this goes upstream.
>
> Alasdair
>

Sorry, for re-post, but it was from mobile in HTML format and it did
not go through...

Do not look to it as integrity from reliability point of view. This
might be a wrong name for the target.
The purpose is to provide integrity from security point of view, so
modified blocks are not available.
It is to prevent attacker to put arbitrary content. This is not in
fact to provide reliability.
Default is to return an error. But returning zeroed data might be a
better option.
It works as needed for the purpose and data=journal works for this if
reliability is required.

- Dmitry
