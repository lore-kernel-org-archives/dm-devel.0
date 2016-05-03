From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 19/57] multipathd: Do not print misleading
 message 'not found in pathvec'
Date: Tue, 3 May 2016 07:47:36 +0200
Message-ID: <57283B78.6010003@suse.de>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
	<1461755458-29225-20-git-send-email-hare@suse.de>
	<20160502154029.GQ26117@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160502154029.GQ26117@octiron.msp.redhat.com>
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On 05/02/2016 05:40 PM, Benjamin Marzinski wrote:
> On Wed, Apr 27, 2016 at 01:10:20PM +0200, Hannes Reinecke wrote:
>> When looking up a path in the existing configuration it is perfectly
>> possible for the path not to be present.
>> This should not generate a message as it might be errorneously
>> interpreted as an error.
>>
> =

> Do you feel really strongly that these messages should go? I don't think
> that they are essential, but they can be useful when debugging an issue
> to see the route the code took. We could move them to level 4, but
> personally, I find the amount of messages generated at log level 4 to be
> so high that it's a pain to use to track bugs that don't occur right
> away. Another possibility would be to change the message to something
> more innocuous.
> =

I'm not particulary attached to this patch.
The main issues I have is that we're generating two identical messages
at two different locations (ie making it hard to debug), and that the
message don't indicate whether it's an error or not.

But sure, I can easily drop this patch.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
