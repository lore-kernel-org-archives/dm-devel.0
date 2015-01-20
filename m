From: Nick Krause <xerofoify@gmail.com>
Subject: Re: [PATCH RESEND] md:Remove no longer needed fix me
 comment in dm-region-hash.c for removing the structure pointer,
 *rh from the definiton of dm_region
Date: Tue, 20 Jan 2015 08:17:47 -0500
Message-ID: <CAPDOMVi8LE6qHQb4iEU1ZNcBz4dbi0OZvMYDqarpU=btc0NnkQ@mail.gmail.com>
References: <1421723781-21984-1-git-send-email-xerofoify@gmail.com>
	<20150120111951.GB17599@agk-dp.fab.redhat.com>
	<54BE3DAA.5080900@gmail.com>
	<20150120114032.GC17599@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150120114032.GC17599@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: nick <xerofoify@gmail.com>, agk@redhat.com, linux-raid@vger.kernel.org, dm-devel@redhat.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, snitzer@redhat.com
List-Id: dm-devel.ids

On Tue, Jan 20, 2015 at 6:40 AM, Alasdair G Kergon <agk@redhat.com> wrote:
> On Tue, Jan 20, 2015 at 06:36:10AM -0500, nick wrote:
>> Unless we use a union or something similar there seems to be no easy
>> way without rewriting a lot of an already function driver file.
>
> The comment does not restrict itself to 'easy ways'.
>
> Alasdair
>
>
Then I suggest that I look into this form. Sorry about wasting your time.
Nick
