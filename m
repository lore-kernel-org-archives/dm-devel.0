From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 1/2] multipath-tools: fix compilation with
 gcc < 4.9 on dash shell
Date: Mon, 30 Jul 2018 19:59:41 +0000
Message-ID: <44ef8adf3a2b2dcb21f8a56c62c89044a674ead4.camel@wdc.com>
References: <20180730193745.21775-1-mfo@canonical.com>
	<20180730193745.21775-2-mfo@canonical.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4905101161479245288=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180730193745.21775-2-mfo@canonical.com>
Content-Language: en-US
Content-ID: <9981F8EE8BE71E4AB3B6A7F5E0C8C4C2@namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "mfo@canonical.com" <mfo@canonical.com>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============4905101161479245288==
Content-Language: en-US
Content-Type: text/plain; charset="utf-7"
Content-ID: <9981F8EE8BE71E4AB3B6A7F5E0C8C4C2@namprd04.prod.outlook.com>
Content-Transfer-Encoding: 8bit

On Mon, 2018-07-30 at 16:37 -0300, Mauricio Faria de Oliveira wrote:
+AD4- diff --git a/Makefile.inc b/Makefile.inc
+AD4- index af2f5bae09d3..a12b46ef315e 100644
+AD4- --- a/Makefile.inc
+AD4- +-+-+- b/Makefile.inc
+AD4- +AEAAQA- -78,7 +-78,7 +AEAAQA- INSTALL+AF8-PROGRAM	+AD0- install
+AD4-  +ACM- Test if the C compiler supports the option.
+AD4-  +ACM- Evaluates to +ACI-option+ACI- if yes, and +ACI-fallback+ACI- otherwise.
+AD4-  TEST+AF8-CC+AF8-OPTION +AD0- +ACQ-(shell +AFw-
+AD4- -	if echo 'int main(void)+AHs-return 0+ADsAfQ-' +AHw- +ACQ-(CC) -o /dev/null -c +ACIAJA-(1)+ACI- -xc - +ACYAPg-/dev/null+ADs- +AFw-
+AD4- +-	if echo 'int main(void)+AHs-return 0+ADsAfQ-' +AHw- +ACQ-(CC) -o /dev/null -c +ACIAJA-(1)+ACI- -xc - +AD4-/dev/null 2+AD4AJg-1+ADs- +AFw-
+AD4-  	then +AFw-
+AD4-  		echo +ACIAJA-(1)+ACIAOw- +AFw-
+AD4-  	else +AFw-

Reviewed-by: Bart Van Assche +ADw-bart.vanassche+AEA-wdc.com+AD4-




--===============4905101161479245288==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4905101161479245288==--
