From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: [RFC] dm-writeboost: Plan to add comments. Needs help to
 make an objective list of where to comment
Date: Mon, 16 Sep 2013 22:49:09 +0900
Message-ID: <52370C55.6060906@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: gregkh@linuxfoundation.org, agk@redhat.com
List-Id: dm-devel.ids

Hi,

I am thinking of adding more comments on the source code
according to the Alasdair's advice.

According to the Chapter 8 "Commenting" in Documentation/CodingStyle
WHAT it does should be commented
while HOW it works should not be but should be explained by the source code.

I was believing that only about the design issue
should be commented for the code quality.
But, on the second thought,
Linux kernel is a huge OSS 
that developers are living different timezone
and in different physical locations.
So, comments are almost all the information
that they can get beside the source code
because we can't easily chat with each other and ping pong Q&A.
That I am living in Japan might make the situation even worse.

Now that dm-writeboost is consist of 3.5k lines of code
and more 500 or 1000 lines of comments added
doesn't affect the maintainability so much.
Therefore, commenting will be paid in case of dm-writeboost.

I will be starting from commenting on WHAT it does
in the source code
including adding explanation on what the routine does
in front of the routines.

But the problem is that
I have no idea where to write comments at all.

I want to make an _objective_ list of where to comment.
Someone help me make the list?
I ask you to
read thru the code,
pick up where you couldn't understand or feel needing comments
and then report the list to me.
It will be helping a lot.

Thanks,
Akira
