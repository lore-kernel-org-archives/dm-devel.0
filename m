From: Hannes Reinecke <hare@suse.de>
Subject: SUSE multipath-tools resync
Date: Thu, 05 May 2011 09:37:54 +0200
Message-ID: <4DC253D2.1090907@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Christophe,

I'm currently rebasing my multipath-tools git tree to the latest =

upstream version and planning on sending out the missing patches.

However, I found that I should've done that far earlier; so far I've =

accumulated about 40-odd patches and I'm only halfway through the =

resulting diff :-(

How do you prefer those patches? Should I send them off in one bulk =

or rather several smaller batches?

Most of them are totally unrelated, just various fixes here and =

there. So it doesn't really matter in which order they'll be applied.
Only some patches are for infrastructure changes :-)

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
