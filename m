From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Was: [patch 1/1] md/dm: Reduce stack usage with stacked
	block devices
Date: Wed, 11 Jan 2006 13:45:41 +0100
Message-ID: <62b0912f0601110445w34d480c4n56d8f02056baef26@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com
Cc: akpm@osdl.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Alasdair G Kergon wrote:
> My main concern is whether the timing changes implicit in this patch
> will make the rare data-corrupting races in the existing snapshot code
> more likely.

Haha!  Rare my a** :-).

> (I'm working on a fix for these races, but the unfinished
> patch is already several hundred lines long.)

Sounds cool.
A few questions, if you have the time:

* Do you think that there is only 1 data corruption bug in dm snapshot
and that the code is otherwise good (data consistency wise)?

* Is dm-snapshot being actively developed?

* Which organization/person is the main developer on dm-snapshot?

> It would be helpful if some people on this mailing list would test
> this patch in various scenarios and report back.

I'd be more than happy to test improvements to dm-snapshot.
Is this supposed to be one?

What's the codebase that this patch applies to?
