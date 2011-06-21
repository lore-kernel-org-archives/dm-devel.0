From: Joe Thornber <thornber@redhat.com>
Subject: Re: Interface changes to multisnap
Date: Tue, 21 Jun 2011 14:59:51 +0100
Message-ID: <20110621135949.GA2122@ubuntu>
References: <20110620122256.GA15181@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20110620122256.GA15181@ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Jun 20, 2011 at 01:22:57PM +0100, Joe Thornber wrote:
> I've just pushed an interface change for multisnap.

Ignore the previous message, it turned out to be bogus.  So now
resizing is implemented as follows:

- new-thin still takes a size arg

  new-thin <id> <size in sectors>

- There is a resize message:

  resize <id> <size in sectors>

- The target length doesn't have to correspond to the size of the thin
  device.  Writes beyond the end will cause IO error.

- Multiple targets may point to the same thin device.  If you make
  more than one active then it is a user error.  Much like using a
  linear target to map multiple devices to the same physical disk.

- Joe
