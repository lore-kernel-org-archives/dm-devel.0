From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: 2 TB wraparound on snapshots
Date: Sat, 12 Jun 2010 18:03:39 -0400
Message-ID: <4C14043B.7080203@cfl.rr.com>
References: <4C12A32C.3000501@cfl.rr.com>	<1276290990.2862.161.camel@mulgrave.site>	<4C13AB90.1070802@cfl.rr.com>	<1276358598.4399.3.camel@mulgrave.site>	<1276358949.4399.8.camel@mulgrave.site>
	<4C13CAD6.70902@cfl.rr.com>	<4C13D65B.7010800@cfl.rr.com>
	<1276373001.4399.11.camel@mulgrave.site>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1276373001.4399.11.camel@mulgrave.site>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On 06/12/2010 04:03 PM, James Bottomley wrote:
> So do you have a 64 bit system (like an amd64) that you can try this
> with?  If it only occurs on the i686 system, then it's likely a long to
> sector conversion bug somewhere in the snapshot code.  If it occurs on
> both, there's some 2TB limit coded directly into snapshots.

As I said before, it occurs on both.
