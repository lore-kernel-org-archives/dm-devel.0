From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 18/32] libmultipath: fix tur memory misuse
Date: Sun, 5 Aug 2018 15:43:18 +0000
Message-ID: <c2e5237d7ee818ce90f4ed749493c970f17178c8.camel@wdc.com>
References: <1533157038-3924-1-git-send-email-bmarzins@redhat.com>
	<1533157038-3924-19-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2770439302113518717=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1533157038-3924-19-git-send-email-bmarzins@redhat.com>
Content-Language: en-US
Content-ID: <85330F9D22561546B94D084F287B5010@namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "bmarzins@redhat.com" <bmarzins@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
Cc: "mwilck@suse.com" <mwilck@suse.com>
List-Id: dm-devel.ids

--===============2770439302113518717==
Content-Language: en-US
Content-Type: text/plain; charset="utf-7"
Content-ID: <85330F9D22561546B94D084F287B5010@namprd04.prod.outlook.com>
Content-Transfer-Encoding: 8bit

On Wed, 2018-08-01 at 15:57 -0500, Benjamin Marzinski wrote:
+AD4- when tur+AF8-thread() was calling tur+AF8-check(), it was passing ct-+AD4-message as
+AD4- the copy argument, but copy+AF8-msg+AF8-to+AF8-tcc() was assuming that it was
+AD4- getting a tur+AF8-checker+AF8-context pointer. This means it was treating
+AD4- ct-+AD4-message as ct. This is why the tur checker never printed checker
+AD4- messages. Intead of simply changing the copy argument passed in, I just
+AD4- removed all the copying code, since it is completely unnecessary. The
+AD4- callers of tur+AF8-check() can just pass in a buffer that it is safe to
+AD4- write to, and copy it later, if necessary.
+AD4- +AFs- ... +AF0-
+AD4- -+ACM-define TUR+AF8-MSG(fmt, args...)					+AFw-
+AD4- -	do +AHs-							+AFw-
+AD4- -		char msg+AFs-CHECKER+AF8-MSG+AF8-LEN+AF0AOw-			+AFw-
+AD4- -								+AFw-
+AD4- -		snprintf(msg, sizeof(msg), fmt, +ACMAIw-args)+ADs-	+AFw-
+AD4- -		copy+AF8-message(cb+AF8-arg, msg)+ADs-			+AFw-
+AD4- -	+AH0- while (0)
+AD4- -
+AD4- +AFs- ... +AF0-
+AD4- -static void copy+AF8-msg+AF8-to+AF8-tcc(void +ACo-ct+AF8-p, const char +ACo-msg)
+AD4- -+AHs-
+AD4- -	struct tur+AF8-checker+AF8-context +ACo-ct +AD0- ct+AF8-p+ADs-
+AD4- -
+AD4- -	pthread+AF8-mutex+AF8-lock(+ACY-ct-+AD4-lock)+ADs-
+AD4- -	strlcpy(ct-+AD4-message, msg, sizeof(ct-+AD4-message))+ADs-
+AD4- -	pthread+AF8-mutex+AF8-unlock(+ACY-ct-+AD4-lock)+ADs-
+AD4- -+AH0-

The above code was introduced because multiple threads can access ct-+AD4-message
concurrently. Does your patch reintroduce the race conditions on the ct-+AD4-message
buffer that were fixed by commit f63f4d115813 (+ACI-libmultipath/checkers/tur: Protect
tur+AF8-checker+AF8-context.message changes+ACI-)?

Bart.




--===============2770439302113518717==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2770439302113518717==--
