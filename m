Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44CF4288CA6;
	Mon, 22 Sep 2025 12:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758544047; cv=none; b=JKW4Bxmmhpf9HBjz1cqPOdFmYCe2mCj7QhnyGvA8sLzRLk+FSlCg5xY2UQXZ1hO3D4thrn0fjL1W73cCHubNxSJ494+5TcYZV4uyXUpYbde5IokWOFDevjNpb1nGHGSg7/ZQ33H6CGUzMPVFIctaYpaqwwyCjtD/g5lIn3raf5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758544047; c=relaxed/simple;
	bh=7ocyK+3FzD6V+C25dQYZW41KRJc+fHbACGeGMEnQN5g=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=KgoS15yp1VzHhnnB9rVXh/CUjXWUy5E9+eZSgWzKWw6OI5Jm41/UiTsPO8JjaGgIyKdkK+3uPIJ58qj580g6yCCgbHzguKcjbWYgfs+zUCAHIc/5boX3XW/XlgZMQvbp6NNOwEyvTyqBpYLOpsIv4iXcACxoYRM4QKexhtur6R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JcqUJiPm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JcqUJiPm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C696C116B1;
	Mon, 22 Sep 2025 12:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758544046;
	bh=7ocyK+3FzD6V+C25dQYZW41KRJc+fHbACGeGMEnQN5g=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=JcqUJiPmkQt1Wtj2boeGm6ynazYCaFwP45kTBA1K5E5xobdGe3n9FRj63J43/elTW
	 HCLEbRA43DsEy3HdMnu2rRRllp49AB/iHuVJ21d7sKfRruRksjsqvPf54ywINOqxuj
	 2/4brXazhZ6QCJ9bWcIIzfmWngrTXftz2POrLXmk=
Subject: Patch "minmax: simplify and clarify min_t()/max_t() implementation" has been added to the 6.6-stable tree
To: David.Laight@ACULAB.COM,David.Laight@aculab.com,Rodrigo.Siqueira@amd.com,Xinhui.Pan@amd.com,agk@redhat.com,airlied@gmail.com,akpm@linux-foundation.org,alexander.deucher@amd.com,alexandre.torgue@foss.st.com,amd-gfx@lists.freedesktop.org,andriy.shevchenko@linux.intel.com,anton.ivanov@cambridgegreys.com,arnd@kernel.org,artur.paszkiewicz@intel.com,bp@alien8.de,christian.koenig@amd.com,clm@fb.com,daniel@ffwll.ch,dave.hansen@linux.intel.com,davem@davemloft.net,dm-devel@lists.linux.dev,dmitry.torokhov@gmail.com,dri-devel@lists.freedesktop.org,dsahern@kernel.org,dsterba@suse.com,edumazet@google.com,evan.quan@amd.com,farbere@amazon.com,gregkh@linuxfoundation.org,harry.wentland@amd.com,hdegoede@redhat.com,hpa@zytor.com,ilpo.jarvinen@linux.intel.com,james.morse@arm.com,jdelvare@suse.com,jejb@linux.ibm.com,jernej.skrabec@gmail.com,joabreu@synopsys.com,johannes@sipsolutions.net,josef@toxicpanda.com,keescook@chromium.org,krzysztof.kozlowski@linaro.org,kuba@kernel.org,linus.walleij@linaro.org,linux-arm-kernel@lists.infradead.org,linux-mm@kvack.org,linux-staging@lists.linux.dev,linux-stm32@st-md-mailman.stormreply.com,linux-sunxi@lists.linux.dev,linux-um@lists.infradead.org,linux@rasmusvillemoes.dk,linux@roeck-us.net,lorenzo.stoakes@oracle.com,luc.vanoostenryck@gmail.com,luto@kernel.org,maarten.lankhorst@linux.intel.com,mailhol.vincent@wanadoo.fr,malattia@linux.it,markgross@kernel.org,martin.petersen@oracle.com,mchehab@kernel.org,mcoquelin.stm32@gmail.com,mhiramat@kernel.org,minchan@kernel.org,mingo@redhat.com,mkl@pengutronix.de,mripard@kernel.org,pabeni@redhat.com,peterz@infradead.org,pmladek@suse.com,qiuxu.zhuo@intel.com,richard@nod.at,rostedt@goodmis.org,rric@kernel.org,sakari.ailus@linux.intel.com,samuel@sholland.org,senozhatsky@chromium.org,shuah@kernel.org,snitzer@kernel.org,sunpeng.li@amd.com,tglx@linutronix.de,tony.luck@intel.com,torvalds@linux-foundation.org,tzimmermann@suse.de,wad@chromium.org,wens@csie.org,wg@grandegger.com,x86@kernel.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Mon, 22 Sep 2025 14:27:00 +0200
In-Reply-To: <20250922103241.16213-3-farbere@amazon.com>
Message-ID: <2025092200-backache-provolone-1ed1@gregkh>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore


This is a note to let you know that I've just added the patch titled

    minmax: simplify and clarify min_t()/max_t() implementation

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     minmax-simplify-and-clarify-min_t-max_t-implementation.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From prvs=353d6d59a=farbere@amazon.com Mon Sep 22 12:34:24 2025
From: Eliav Farber <farbere@amazon.com>
Date: Mon, 22 Sep 2025 10:32:28 +0000
Subject: minmax: simplify and clarify min_t()/max_t() implementation
To: <richard@nod.at>, <anton.ivanov@cambridgegreys.com>, <johannes@sipsolutions.net>, <dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <james.morse@arm.com>, <mchehab@kernel.org>, <rric@kernel.org>, <harry.wentland@amd.com>, <sunpeng.li@amd.com>, <Rodrigo.Siqueira@amd.com>, <alexander.deucher@amd.com>, <christian.koenig@amd.com>, <Xinhui.Pan@amd.com>, <airlied@gmail.com>, <daniel@ffwll.ch>, <evan.quan@amd.com>, <maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>, <tzimmermann@suse.de>, <jdelvare@suse.com>, <linux@roeck-us.net>, <linus.walleij@linaro.org>, <dmitry.torokhov@gmail.com>, <wens@csie.org>, <jernej.skrabec@gmail.com>, <samuel@sholland.org>, <agk@redhat.com>, <snitzer@kernel.org>, <dm-devel@lists.linux.dev>, <mailhol.vincent@wanadoo.fr>, <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>, <alexandre.torgue@foss.st.com>, <joabreu@synopsys.com>, <mcoquelin.stm32@gmail.com>, <krzysztof.kozlowski@linaro.org>, <malattia@linux.it>, <hdegoede@redhat.com>, <ilpo.jarvinen@linux.intel.com>, <markgross@kernel.org>, <artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>, <gregkh@linuxfoundation.org>, <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <mhiramat@kernel.org>, <pmladek@suse.com>, <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>, <senozhatsky@chromium.org>, <minchan@kernel.org>, <akpm@linux-foundation.org>, <dsahern@kernel.org>, <shuah@kernel.org>, <keescook@chromium.org>, <wad@chromium.org>, <farbere@amazon.com>, <David.Laight@ACULAB.COM>, <arnd@kernel.org>, <linux-um@lists.infradead.org>, <linux-kernel@vger.kernel.org>, <linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, <linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>, <linux-sunxi@lists.linux.dev>, <linux-media@vger.kernel.org>, <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>, <platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>, <linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>, <linux-sparse@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <linux-kselftest@vger.kernel.org>, <bpf@vger.kernel.org>, <stable@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, David Laight <David.Laight@aculab.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Message-ID: <20250922103241.16213-3-farbere@amazon.com>

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 017fa3e89187848fd056af757769c9e66ac3e93d ]

This simplifies the min_t() and max_t() macros by no longer making them
work in the context of a C constant expression.

That means that you can no longer use them for static initializers or
for array sizes in type definitions, but there were only a couple of
such uses, and all of them were converted (famous last words) to use
MIN_T/MAX_T instead.

Cc: David Laight <David.Laight@aculab.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/minmax.h |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -45,17 +45,20 @@
 
 #define __cmp(op, x, y)	((x) __cmp_op_##op (y) ? (x) : (y))
 
-#define __cmp_once(op, x, y, unique_x, unique_y) ({	\
-	typeof(x) unique_x = (x);			\
-	typeof(y) unique_y = (y);			\
+#define __cmp_once_unique(op, type, x, y, ux, uy) \
+	({ type ux = (x); type uy = (y); __cmp(op, ux, uy); })
+
+#define __cmp_once(op, type, x, y) \
+	__cmp_once_unique(op, type, x, y, __UNIQUE_ID(x_), __UNIQUE_ID(y_))
+
+#define __careful_cmp_once(op, x, y) ({			\
 	static_assert(__types_ok(x, y),			\
 		#op "(" #x ", " #y ") signedness error, fix types or consider u" #op "() before " #op "_t()"); \
-	__cmp(op, unique_x, unique_y); })
+	__cmp_once(op, __auto_type, x, y); })
 
 #define __careful_cmp(op, x, y)					\
 	__builtin_choose_expr(__is_constexpr((x) - (y)),	\
-		__cmp(op, x, y),				\
-		__cmp_once(op, x, y, __UNIQUE_ID(__x), __UNIQUE_ID(__y)))
+		__cmp(op, x, y), __careful_cmp_once(op, x, y))
 
 #define __clamp(val, lo, hi)	\
 	((val) >= (hi) ? (hi) : ((val) <= (lo) ? (lo) : (val)))
@@ -158,7 +161,7 @@
  * @x: first value
  * @y: second value
  */
-#define min_t(type, x, y)	__careful_cmp(min, (type)(x), (type)(y))
+#define min_t(type, x, y) __cmp_once(min, type, x, y)
 
 /**
  * max_t - return maximum of two values, using the specified type
@@ -166,7 +169,7 @@
  * @x: first value
  * @y: second value
  */
-#define max_t(type, x, y)	__careful_cmp(max, (type)(x), (type)(y))
+#define max_t(type, x, y) __cmp_once(max, type, x, y)
 
 /*
  * Do not check the array parameter using __must_be_array().


Patches currently in stable-queue which might be from farbere@amazon.com are

queue-6.6/minmax-don-t-use-max-in-situations-that-want-a-c-constant-expression.patch
queue-6.6/minmax-make-generic-min-and-max-macros-available-everywhere.patch
queue-6.6/minmax-fix-up-min3-and-max3-too.patch
queue-6.6/minmax-add-a-few-more-min_t-max_t-users.patch
queue-6.6/minmax-improve-macro-expansion-and-type-checking.patch
queue-6.6/minmax-avoid-overly-complicated-constant-expressions-in-vm-code.patch
queue-6.6/minmax-simplify-min-max-clamp-implementation.patch
queue-6.6/minmax-simplify-and-clarify-min_t-max_t-implementation.patch
