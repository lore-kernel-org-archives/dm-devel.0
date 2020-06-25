From: Ferdinand Blomqvist <ferdinand.blomqvist@gmail.com>
Subject: Re: [RFC v2] Reed-Solomon Code: Update no_eras to the actual number
 of errors
Date: Thu, 25 Jun 2020 16:06:24 +0300
Message-ID: <20200625130624.GC1036@mail-personal>
References: <20200625073621.4919-1-aiden.leong@aibsd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200625073621.4919-1-aiden.leong@aibsd.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aiden Leong <aiden.leong@aibsd.com>
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Thomas Gleixner <tglx@linutronix.de>, YueHaibing <yuehaibing@huawei.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Hi!

On 2020-06-25 00:36:01, Aiden Leong wrote:
>Corr and eras_pos are updated to actual correction pattern and erasure
>positions, but no_eras is not.
>
>When this library is used to recover lost bytes, we normally memset the
>lost trunk of bytes to zero as a placeholder. Unfortunately, if the lost
>byte is zero, b[i] is zero too. Without correct no_eras, users won't be
>able to determine the valid length of corr and eras_pos.
>
>Signed-off-by: Aiden Leong <aiden.leong@aibsd.com>

I'm not sure I understand what you try to do. decode_rs* already returns
the number of errors correted (or something negative upon failure). So
your last statment is false. The lengt of corr and eras_pos is returned
by the function. So this change is unnecessary. More comments inline.

>
>diff --git a/lib/reed_solomon/decode_rs.c b/lib/reed_solomon/decode_rs.c
>index 805de84ae83d..44136ea33d16 100644
>--- a/lib/reed_solomon/decode_rs.c
>+++ b/lib/reed_solomon/decode_rs.c
>@@ -24,6 +24,7 @@
> 	int count = 0;
> 	int num_corrected;
> 	uint16_t msk = (uint16_t) rs->nn;
>+	int no_eras_local = no_eras ? *no_eras : 0;
>
> 	/*
> 	 * The decoder buffers are in the rs control struct. They are
>@@ -106,11 +107,11 @@
> 	memset(&lambda[1], 0, nroots * sizeof(lambda[0]));
> 	lambda[0] = 1;
>
>-	if (no_eras > 0) {
>+	if (no_eras_local > 0) {
> 		/* Init lambda to be the erasure locator polynomial */
> 		lambda[1] = alpha_to[rs_modnn(rs,
> 					prim * (nn - 1 - (eras_pos[0] + pad)))];
>-		for (i = 1; i < no_eras; i++) {
>+		for (i = 1; i < no_eras_local; i++) {
> 			u = rs_modnn(rs, prim * (nn - 1 - (eras_pos[i] + pad)));
> 			for (j = i + 1; j > 0; j--) {
> 				tmp = index_of[lambda[j - 1]];
>@@ -129,8 +130,8 @@
> 	 * Begin Berlekamp-Massey algorithm to determine error+erasure
> 	 * locator polynomial
> 	 */
>-	r = no_eras;
>-	el = no_eras;
>+	r = no_eras_local;
>+	el = no_eras_local;
> 	while (++r <= nroots) {	/* r is the step number */
> 		/* Compute discrepancy at the r-th step in poly-form */
> 		discr_r = 0;
>@@ -158,8 +159,8 @@
> 				} else
> 					t[i + 1] = lambda[i + 1];
> 			}
>-			if (2 * el <= r + no_eras - 1) {
>-				el = r + no_eras - el;
>+			if (2 * el <= r + no_eras_local - 1) {
>+				el = r + no_eras_local - el;
> 				/*
> 				 * 2 lines below: B(x) <-- inv(discr_r) *
> 				 * lambda(x)
>@@ -312,14 +313,21 @@
> 				eras_pos[j++] = loc[i] - pad;
> 			}
> 		}
>+		if (no_eras)
>+			*no_eras = j;
At this point j will be equal to num_corrected. So why return this
information in no_eras, when it is already returned by the function?

> 	} else if (data && par) {
> 		/* Apply error to data and parity */
>+		j = 0;
> 		for (i = 0; i < count; i++) {
> 			if (loc[i] < (nn - nroots))
> 				data[loc[i] - pad] ^= b[i];
> 			else
> 				par[loc[i] - pad - len] ^= b[i];
>+			if (b[i])
>+				j++;
> 		}
>+		if (no_eras)
>+			*no_eras = j;

Same as above.

>2.25.1
>

Best,
Ferdinand

-- 
Ferdinand Blomqvist
ferdinand.blomqvist[at]gmail.com
GPG key: 9EFB 7A2C 0432 4EC5 32BA FA61 CFE9 4164 93E8 B9E4
