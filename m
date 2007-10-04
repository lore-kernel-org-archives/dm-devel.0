From: Dave Wysochanski <dwysocha@redhat.com>
Subject: RE: Multipath issues with kernel device errors
Date: Thu, 04 Oct 2007 14:49:06 -0400
Message-ID: <1191523746.4406.15.camel@linux-cxyg>
References: <8CED8CEBA23FC0409E1A3009F7F47BE502471065@exchange.g2switchworks.com>
	<1188333723.12737.7.camel@linuxchandra>
	<8CED8CEBA23FC0409E1A3009F7F47BE502471086@exchange.g2switchworks.com>
	<1188338656.12737.18.camel@linuxchandra> <46D50ECF.6020701@suse.de>
	<8CED8CEBA23FC0409E1A3009F7F47BE5024711B7@exchange.g2switchworks.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <8CED8CEBA23FC0409E1A3009F7F47BE5024711B7@exchange.g2switchworks.com>
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

On Wed, 2007-08-29 at 11:58 -0500, Jeffry Bilder wrote:
> Are the errors in the kernel log normal:
> 
> 
> Aug 28 10:30:15 rac02 kernel: end_request: I/O error, dev sdf, sector 513824
> Aug 28 10:30:15 rac02 kernel: Buffer I/O error on device sdf, logical block 64228
> Aug 28 10:30:15 rac02 kernel: Buffer I/O error on device sdf, logical block 64229
> Aug 28 10:30:15 rac02 kernel: Buffer I/O error on device sdf, logical block 64230
> Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical block 64231
> Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical block 64232
> Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical block 64233
> Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical block 64234
> Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical block 64235
> Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical block 64236
> Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical block 64237
> Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical block 64238
> Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical block 64239
> Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical block 64240
> Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical block 64241
> Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical block 64242
> Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical block 64243
> Aug 28 10:30:16 rac02 kernel: Device sdf not ready.
> Aug 28 10:30:16 rac02 kernel: end_request: I/O error, dev sdf, sector 513824
> Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical block 64228
> Aug 28 10:30:16 rac02 kernel: Device sdf not ready.
> Aug 28 10:30:16 rac02 kernel: end_request: I/O error, dev sdf, sector 513824
> Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical block 64228
> Aug 28 10:30:16 rac02 kernel: Device sdf not ready.
> Aug 28 10:30:16 rac02 kernel: end_request: I/O error, dev sdf, sector 514064
> Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical block 64258
> Aug 28 10:30:16 rac02 kernel: Device sdf not ready.
> Aug 28 10:30:16 rac02 kernel: end_request: I/O error, dev sdf, sector 513680
> Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical block 64210
> Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical block 64211
> Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical block 64212
> Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical block 64213
> Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical block 64214
> Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical block 64215
> Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical block 64216
> Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical block 64217
> Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical block 64218
> Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical block 64219
> Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical block 64220
> Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical block 64221
> Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical block 64222
> Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical block 64223
> Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical block 64224
> Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical block 64225
> Aug 28 10:30:16 rac02 kernel: Device sdf not ready.
> 
> 

Yes unfortunately these are normal for this array and any array that has
passive paths.  There are fixes needed in the kernel to eliminate these
errors.
