From: Luca Berra <bluca@comedia.it>
Subject: Re: Problem with HP - ML 110 G5
Date: Thu, 4 Feb 2010 08:09:47 +0100
Message-ID: <20100204070947.GA29619@maude.comedia.it>
References: <766AD601A3F2BC4BB5C12D5CC0678B0614679E@tecsystem.TecSystem.local>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <766AD601A3F2BC4BB5C12D5CC0678B0614679E@tecsystem.TecSystem.local>
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

On Wed, Feb 03, 2010 at 05:12:38PM -0200, Ronei Kliemann wrote:
>Feb  3 08:31:35 Backup_DrClin kernel: device-mapper: table: 253:0: mirror: Device lookup failure
>
>Feb  3 08:31:35 Backup_DrClin kernel: device-mapper: ioctl: error adding target to table
>
>Feb  3 08:31:35 Backup_DrClin kernel: device-mapper: ioctl: device doesn't appear to be in the dev hash table.

modprobe dm-mirror?

L.

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
