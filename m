From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/2] dm-crypt: Properly handle extra key
 string in initialization
Date: Tue, 29 Oct 2013 20:49:09 -0400
Message-ID: <20131030004909.GA3537@redhat.com>
References: <1382275000-10660-1-git-send-email-gmazyland@gmail.com>
	<1382998864-10380-1-git-send-email-gmazyland@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1382998864-10380-1-git-send-email-gmazyland@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <gmazyland@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Oct 28 2013 at  6:21pm -0400,
Milan Broz <gmazyland@gmail.com> wrote:

> Some encryption modes use extra keys (e.g. loopAES has IV seed)
> which are not used in block cipher initialization but are part
> of key string in table constructor.
> 
> Patch adds additional field which described lenght of this extra
> keys and substracts it before real key encryption setting.
> 
> So the key_size always includes the size of provided key
> in mapping table in bytes.
> 
> The key_parts descibes how many parts (usually keys) contains
> the whole key buffer and key_extra_size contains size in bytes
> of additional keys part (this number of bytes must be cut off
> because is processed by IV generator).
> 
> | K1 | K2 | .... | K64 |      Kiv       |
> |----------- key_size ----------------- |
> |                      |-key_extra_size-|
> |     [64 keys]           [1 key]       | => key_parts = 65
> 
> Example where key string contains main key K, whitening key
> Kw and IV seed Kiv:
> 
> |     K       |   Kiv   |       Kw       |
> |--------------- key_size ---------------|
> |             |-----key_extra_size-------|
> |  [1 key]    | [1 key] |     [1 key]    | => key_parts = 3
> 
> Because extra keys are calculated during IV mode setting,
> key initialization is moved after this step.
> 
> For now, this change has no effect to supported modes
> (thanks to ilog2 rounding) but is required by following patch.
> 
> Signed-off-by: Milan Broz <gmazyland@gmail.com>

I pushed this to linux-next (for v3.13), see:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=60039e2b0474f4e6b66746b9e179ca384d3e5c96

I tweaked the header a little and some whitespace.
