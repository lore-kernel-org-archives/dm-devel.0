From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: BUG in dm/dm-mirror module?
Date: Mon, 13 Aug 2007 17:21:12 -0400
Message-ID: <46C0CB48.20702@cfl.rr.com>
References: <20070811010853.GA9952@us.ibm.com>
	<46BD78B7.3080200@redhat.com>	<45517CCC-7B68-4B0F-92EC-04F4E81CDA0E@redhat.com>	<46C08B46.8040401@cfl.rr.com>
	<B9BBD91E-F103-40DA-85BA-4FBAF0BB0F59@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <B9BBD91E-F103-40DA-85BA-4FBAF0BB0F59@redhat.com>
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

Jonathan Brassow wrote:
> It is a special problem with the mirror log.
> 
> Mirrors will recover themselves and become consistent upon a reboot.  In 
> the case of a mirror that holds a file system, if you lost some of your 
> most recent writes, journaling/fsck will take care of it.  In the case 
> of a mirror that holds another mirror's log, you wind up with a log that 
> does not contain recent data - and could spell coherency issues for the 
> top level mirror.

Having a filesystem that is consistent is still not correct if it is 
older data, at least not when the newer data is available.

> There is no metadata on the other drive, that's part of the problem.  We 
> must discern between metadata that is made by LVM (or other userspace 
> app) and meta-data areas that are known to the device mapper target.  
> Currently, the mirroring target only has the log device - which I 
> contend is insufficient.

LVM needs to update its metadata to indicate that the other drive failed 
and this one now contains more up to date information going forward.
