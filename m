From: Stefan Bader <Stefan.Bader@de.ibm.com>
Subject: Re: [RFC,	PATCH] dm-log.c: Work with devices with
	hard-sector-size > 512 bytes
Date: Tue, 28 Mar 2006 14:20:40 +0200
Message-ID: <OFF9070A97.1B2B4FBF-ONC125713F.0043348E-C125713F.0043C3DD@de.ibm.com>
References: <200603271546.25508.kevcorry@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200603271546.25508.kevcorry@us.ibm.com>
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

> 
> Unfortunately, the on-disk bitset is hardcoded to be at sector 2, which
> is too small for any device with hard-sector-size > 1k. I've changed
> this offset to sector 64 (32k from start of device), which should be a
> safer choice. However, this necessitated a change of the disk-log 
version
> from 2 to 3, meaning the new code would not be compatible with any
> existing disk-logs. At the moment, I haven't added any code to deal with
> this scenario - I wanted to get some opinions on how to best handle 
this.
> 

Would it really hurt to leave the sector offset just at 2? That way the
bitset data starts at different byte offsets but that would be consistent
with the device. A fix byte offset would only be needed if a device could
change its hardsector size without loosing data, wouldn't it?

Regards,
Stefan Bader
