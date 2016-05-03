From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 23/57] multipath: remove warning 'failed to
	get wwid'
Date: Tue, 3 May 2016 07:48:36 +0200
Message-ID: <57283BB4.9000107@suse.de>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
	<1461755458-29225-24-git-send-email-hare@suse.de>
	<20160502154300.GR26117@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160502154300.GR26117@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Hannes Reinecke <hare@suse.com>, Mike Snitzer <snitzer@redhat.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On 05/02/2016 05:43 PM, Benjamin Marzinski wrote:
> On Wed, Apr 27, 2016 at 01:10:24PM +0200, Hannes Reinecke wrote:
> =

> Again. I'd prefer leaving the messages in either at a higher log level
> or with less alarming text.
> =

I'm fine with moving it to log level 4.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
