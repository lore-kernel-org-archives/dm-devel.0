From: "goggin, edward" <egoggin@emc.com>
Subject: RE: [Bug 164617] extracting tar image causes paths sta
	te	change to [ready][failed]
Date: Tue, 2 Aug 2005 16:12:43 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321AB9C@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, 29 Jul 2005 15:35:25 +0200
christophe varoqui <christophe.varoqui@free.fr> wrote
> Subject: [dm-devel] [Bug 164617] extracting tar image causes paths
> 	state	change to [ready][failed]
> To: narasimha.murthy@hp.com
> Cc: device-mapper development <dm-devel@redhat.com>
> Message-ID: <1122644125.3569.37.camel@zezette>
> Content-Type: text/plain
> 
> Will provide the following additional info :
> 
> Was the daemon runing ?
> If so paste a verbose daemon log.
> Paste a dmesg too.

Talking with Narasimha on the weekly multipathing conference call,
it seems this problem only occurs when a second multipath mapped
device is manually created via dmsetup to utilize the SAME paths
as a multipath mapped device already configured by multipath(8).

Seems to me that neither multipath nor multipathd will react well
to this configuration since there is but a single path data structure
for each physical path and each path structure has but a single link
to its multipath data structure.

It also seems that the kernel dm code should not be allowing this to
happen, that is, a target device should not be used as a target of
more than a single device-mapper mapped device.

Target devices are claimed for use by but a single exclusive open via
a call to bd_claim in open_dev, but the device-mapper uses the same
claim holder value for all target devices -- thereby allowing the same
device to be a target device of multiple mapped devices.

A possible fix here is to use a claim holder value (ptr to mapped
device possibly) which is unique for each mapped device -- thereby
causing an attempt to create a mapped device using a target device
of an already existing mapped device to fail.

I can experiment with this and get a patch as soon as I have a host to use.
