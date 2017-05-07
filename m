From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [BUG] multipath-tools: missing internal values
 (multipath -t)
Date: Sun, 7 May 2017 02:40:45 +0200
Message-ID: <60aa04af-4872-7ba5-f412-59750257541f@gmail.com>
References: <5a9ce04c-3996-9f88-1682-822b0d7b9e65@gmail.com>
	<20170425184224.GV19236@octiron.msp.redhat.com>
	<CABr-Gnd_6OnfOGrdyW2SYftoT6V+-V7RAANCBsVncVLgxtEuKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABr-Gnd_6OnfOGrdyW2SYftoT6V+-V7RAANCBsVncVLgxtEuKg@mail.gmail.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 04/27/2017 09:10 AM, Christophe Varoqui wrote:

> The config outputed should be usable, so a comment could be printed for the keywords you suggest printing <undef> as the default for.
> 
> Example:
> 
> # no_path_retry <comment explaining the contextual default behaviour>
> 
> or simply
> 
> # no_path_retry <contextual, see man page>

Undefined values should be replaced by "", but this is not the case for 'no_path_retry'.
