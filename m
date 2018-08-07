From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 18/32] libmultipath: fix tur memory misuse
Date: Tue, 7 Aug 2018 21:37:25 +0000
Message-ID: <2bd1e305414442aedc8615f24b0741ac208d4250.camel@wdc.com>
References: <1533157038-3924-1-git-send-email-bmarzins@redhat.com>
	<1533157038-3924-19-git-send-email-bmarzins@redhat.com>
	<c2e5237d7ee818ce90f4ed749493c970f17178c8.camel@wdc.com>
	<20180806231203.GX31378@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8093607384519099350=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180806231203.GX31378@octiron.msp.redhat.com>
Content-Language: en-US
Content-ID: <011123CFB75D45419A81A6AE981B24A5@namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "mwilck@suse.com" <mwilck@suse.com>
List-Id: dm-devel.ids

--===============8093607384519099350==
Content-Language: en-US
Content-Type: text/plain; charset="utf-7"
Content-ID: <011123CFB75D45419A81A6AE981B24A5@namprd04.prod.outlook.com>
Content-Transfer-Encoding: 8bit

On Mon, 2018-08-06 at 18:12 -0500, Benjamin Marzinski wrote:
+AD4- On Sun, Aug 05, 2018 at 03:43:18PM +-0000, Bart Van Assche wrote:
+AD4- +AD4- On Wed, 2018-08-01 at 15:57 -0500, Benjamin Marzinski wrote:
+AD4- +AD4- +AD4- when tur+AF8-thread() was calling tur+AF8-check(), it was passing ct-+AD4-message as
+AD4- +AD4- +AD4- the copy argument, but copy+AF8-msg+AF8-to+AF8-tcc() was assuming that it was
+AD4- +AD4- +AD4- getting a tur+AF8-checker+AF8-context pointer. This means it was treating
+AD4- +AD4- +AD4- ct-+AD4-message as ct. This is why the tur checker never printed checker
+AD4- +AD4- +AD4- messages. Intead of simply changing the copy argument passed in, I just
+AD4- +AD4- +AD4- removed all the copying code, since it is completely unnecessary. The
+AD4- +AD4- +AD4- callers of tur+AF8-check() can just pass in a buffer that it is safe to
+AD4- +AD4- +AD4- write to, and copy it later, if necessary.
+AD4- +AD4- +AD4- +AFs- ... +AF0-
+AD4- +AD4- +AD4- -+ACM-define TUR+AF8-MSG(fmt, args...)					+AFw-
+AD4- +AD4- +AD4- -	do +AHs-							+AFw-
+AD4- +AD4- +AD4- -		char msg+AFs-CHECKER+AF8-MSG+AF8-LEN+AF0AOw-			+AFw-
+AD4- +AD4- +AD4- -								+AFw-
+AD4- +AD4- +AD4- -		snprintf(msg, sizeof(msg), fmt, +ACMAIw-args)+ADs-	+AFw-
+AD4- +AD4- +AD4- -		copy+AF8-message(cb+AF8-arg, msg)+ADs-			+AFw-
+AD4- +AD4- +AD4- -	+AH0- while (0)
+AD4- +AD4- +AD4- -
+AD4- +AD4- +AD4- +AFs- ... +AF0-
+AD4- +AD4- +AD4- -static void copy+AF8-msg+AF8-to+AF8-tcc(void +ACo-ct+AF8-p, const char +ACo-msg)
+AD4- +AD4- +AD4- -+AHs-
+AD4- +AD4- +AD4- -	struct tur+AF8-checker+AF8-context +ACo-ct +AD0- ct+AF8-p+ADs-
+AD4- +AD4- +AD4- -
+AD4- +AD4- +AD4- -	pthread+AF8-mutex+AF8-lock(+ACY-ct-+AD4-lock)+ADs-
+AD4- +AD4- +AD4- -	strlcpy(ct-+AD4-message, msg, sizeof(ct-+AD4-message))+ADs-
+AD4- +AD4- +AD4- -	pthread+AF8-mutex+AF8-unlock(+ACY-ct-+AD4-lock)+ADs-
+AD4- +AD4- +AD4- -+AH0-
+AD4- +AD4- 
+AD4- +AD4- The above code was introduced because multiple threads can access ct-+AD4-message
+AD4- +AD4- concurrently. Does your patch reintroduce the race conditions on the ct-+AD4-message
+AD4- +AD4- buffer that were fixed by commit f63f4d115813 (+ACI-libmultipath/checkers/tur: Protect
+AD4- +AD4- tur+AF8-checker+AF8-context.message changes+ACI-)?
+AD4- 
+AD4- It shouldn't. Since the tur checker thread only has access to the
+AD4- tur+AF8-checker+AF8-context, the only race we have to worry about here is on
+AD4- access to ct-+AD4-message. The main checker code is free to pass c-+AD4-message
+AD4- to tur+AF8-check(), since the tur checker thread doesn't have access to
+AD4- that.  With this patch, tur+AF8-thread() passes tur+AF8-check() a local variable
+AD4- and copies that variable to ct-+AD4-message while holding the mutex.  the
+AD4- main checker code copies ct-+AD4-message to c-+AD4-message while holding the
+AD4- same mutex. The main checker code even clears ct-+AD4-message before
+AD4- starting the thread while holding the mutex.
+AD4- 
+AD4- If you see something I've missed, please let me know.

Hello Ben,

Thanks for the additional clarification. I think this patch is a good improvement
for the TUR checker since it simplifies the code.

Bart.



--===============8093607384519099350==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8093607384519099350==--
