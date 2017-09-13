From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH 4/5] multipath: add alternate reservation_key
 method
Date: Wed, 13 Sep 2017 17:22:59 +0200
Message-ID: <d89bf483-e381-4959-0922-687bcbcc48b6@gmail.com>
References: <1504896354-28181-1-git-send-email-bmarzins@redhat.com>
	<1504896354-28181-5-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1504896354-28181-5-git-send-email-bmarzins@redhat.com>
Content-Language: en-GB
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, device-mapper development <dm-devel@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

On 09/08/2017 08:45 PM, Benjamin Marzinski wrote:

> There are also new multipathd commands to get, set, and unset the
> mappings in the prkesy file. Currently,
> 
> "multipathd map $map setprkey key $key" sets the mapping
> "multipathd map $map unsetprkey" unsets the mapping
> "multipathd map $map getprkey" gets the current reservation_key for a
> multipath device.


multipathd.8 should be updated with these new commands.
