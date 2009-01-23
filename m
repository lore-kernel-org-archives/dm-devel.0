From: Tore Anderson <tore@linpro.no>
Subject: Re: RE: qla2xxx 0000:03:0c.0: Firmware image unavailable
Date: Fri, 23 Jan 2009 08:41:06 +0100
Message-ID: <49797492.8080205@linpro.no>
References: <E463DF2B2E584B4A82673F53D62C2EF45CEAB550@cosmail01.lsi.com>	<D4B83214B57CAC4499F1114D069E451A01A7D6FA@bunker.inside.abhaisystems.com>	<E463DF2B2E584B4A82673F53D62C2EF45CEAB586@cosmail01.lsi.com>	<20090122164616.GF19147@sanger.ac.uk>
	<E463DF2B2E584B4A82673F53D62C2EF45CEAB8A3@cosmail01.lsi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF45CEAB8A3@cosmail01.lsi.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

* Moger, Babu

> Yes, firmware images are in the initrd. I have verified that. 

You should also verify that the firmware loading script is included in
the initramfs image (on Fedora 10 it's called /lib/udev/firmware.sh).

Regards,
-- 
Tore Anderson
Redpill Linpro AS
Kontor: +47 21 54 41 27
