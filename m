From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: Device-mapper target driver for Write tracking
Date: Wed, 19 Oct 2016 13:43:26 +0200
Message-ID: <889366e1-8432-658d-2582-4c7aa7a07dea@redhat.com>
References: <20161019105354.GA17598@sirius.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161019105354.GA17598@sirius.lan>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Daniel Armbruster <dani.armbruster@gmx.de>, dm-devel@redhat.com
Cc: info@xp8.de
List-Id: dm-devel.ids

Dne 19.10.2016 v 12:53 Daniel Armbruster napsal(a):
> Hi List,
>
> I'm looking for a device-mapper target driver giving me the possibility to
> track/log WRITE requests. The idea is to track those WRITE requests within a
> Bitmap e.g. 1:LV-EXTEND (for LVM2). I read already the device-mapper
> documentation under
>
> https://www.kernel.org/doc/Documentation/device-mapper/
>
> but didn't find an appropriate module which would suite my needs.
>
> Is there any work happening on this to leverage? Any kind of help is
> appreciated.
>
> Many thanks in advance.


Hi


Not exactly sure what you are trying to do but 2 things to look at:

Maybe  'dmstats' with it's region logic may cover your 'wanted' operation.

The kernel dm target to check would be  'era' which keeps trace
of written blocks.

Regards

Zdenek
