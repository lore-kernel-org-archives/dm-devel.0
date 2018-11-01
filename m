From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v3 22/22] libmultipath: make checker_message
	thread safe
Date: Thu, 1 Nov 2018 14:53:04 -0500
Message-ID: <20181101195303.GC29522@octiron.msp.redhat.com>
References: <20181030210653.29677-1-mwilck@suse.com>
	<20181030210653.29677-23-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20181030210653.29677-23-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Oct 30, 2018 at 10:06:53PM +0100, Martin Wilck wrote:
> Get rid of the static char buffer in checker_message()
> introduced in the previous "replace message by msgid" patch.


What you have is fine, but why not something like this, which doesn't
need to do any allocating?

diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
index 9d9e3ff..ed75150 100644
--- a/libmultipath/checkers.c
+++ b/libmultipath/checkers.c
@@ -291,7 +291,16 @@ static const char *generic_msg[CHECKER_GENERIC_MSGTABLE_SIZE] = {
 	[CHECKER_MSGID_UNSUPPORTED] = " doesn't support this device",
 };
 
-static const char *_checker_message(const struct checker *c)
+int checker_has_message(const struct checker *c)
+{
+	const char *msg = checker_message(c);
+
+	if (msg == NULL || *msg == '\0')
+		return 0;
+	return 1;
+}
+
+const char *checker_message(const struct checker *c)
 {
 	int id;
 
@@ -309,19 +318,6 @@ static const char *_checker_message(const struct checker *c)
 	return NULL;
 }
 
-char *checker_message(const struct checker *c)
-{
-	static char buf[CHECKER_MSG_LEN];
-	const char *msg = _checker_message(c);
-
-	if (msg == NULL || *msg == '\0')
-		*buf = '\0';
-	else
-		snprintf(buf, sizeof(buf), "%s checker%s",
-			 c->cls->name, msg);
-	return buf;
-}
-
 void checker_clear_message (struct checker *c)
 {
 	if (!c)
diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
index 4e1fdc1..51fd054 100644
--- a/libmultipath/checkers.h
+++ b/libmultipath/checkers.h
@@ -145,7 +145,8 @@ int checker_check (struct checker *, int);
 int checker_selected(const struct checker *);
 int checker_is_sync(const struct checker *);
 const char *checker_name (const struct checker *);
-char *checker_message (const struct checker *);
+const char *checker_message (const struct checker *);
+int checker_has_message(const struct checker *);
 void checker_clear_message (struct checker *c);
 void checker_get(const char *, struct checker *, const char *);
 
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 467ece7..a3d8fee 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1588,9 +1588,9 @@ get_state (struct path * pp, struct config *conf, int daemon, int oldstate)
 	condlog(3, "%s: %s state = %s", pp->dev,
 		checker_name(c), checker_state_name(state));
 	if (state != PATH_UP && state != PATH_GHOST &&
-	    strlen(checker_message(c)))
-		condlog(3, "%s: checker msg is \"%s\"",
-			pp->dev, checker_message(c));
+	    checker_has_message(c))
+		condlog(3, "%s: checker msg is \"%s checker%s\"",
+			pp->dev, checker_name(c), checker_message(c));
 	return state;
 }
 
diff --git a/multipathd/main.c b/multipathd/main.c
index e80ac90..52d6855 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -95,15 +95,11 @@ do {								\
 		if (pp->offline)				\
 			condlog(lvl, "%s: %s - path offline",	\
 				pp->mpp->alias, pp->dev);	\
-		else {						\
-			const char *__m =			\
-				checker_message(&pp->checker);	\
-								\
-			if (strlen(__m))			\
-				condlog(lvl, "%s: %s - %s",	\
-					pp->mpp->alias,		\
-					pp->dev, __m);		\
-		}						\
+		else if (checker_has_message(&pp->checker))	\
+			condlog(lvl, "%s: %s - %s checker%s",	\
+				pp->mpp->alias,	pp->dev,	\
+				checker_name(&pp->checker),	\
+				checker_message(&pp->checker));	\
 	}							\
 } while(0)
 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/checkers.c  | 23 ++++++++++++++++++-----
>  libmultipath/checkers.h  |  4 +++-
>  libmultipath/discovery.c |  9 ++++++---
>  multipathd/main.c        | 11 +++++------
>  4 files changed, 32 insertions(+), 15 deletions(-)
> 
> diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
> index 9a19c9a6..f65a9476 100644
> --- a/libmultipath/checkers.c
> +++ b/libmultipath/checkers.c
> @@ -309,16 +309,29 @@ static const char *_checker_message(const struct checker *c)
>  	return NULL;
>  }
>  
> +int checker_has_message(const struct checker *c)
> +{
> +	const char *msg = _checker_message(c);
> +
> +	if (msg == NULL || *msg == '\0')
> +		return 0;
> +	return 1;
> +}
> +
>  char *checker_message(const struct checker *c)
>  {
> -	static char buf[CHECKER_MSG_LEN];
> +	char *buf;
>  	const char *msg = _checker_message(c);
> +	int len;
>  
>  	if (msg == NULL || *msg == '\0')
> -		*buf = '\0';
> -	else
> -		snprintf(buf, sizeof(buf), "%s checker%s",
> -			 c->cls->name, msg);
> +		return NULL;
> +
> +	len = CHECKER_NAME_LEN + 8 + CHECKER_MSG_LEN;
> +	buf = MALLOC(len);
> +	if (buf == NULL)
> +		return NULL;
> +	snprintf(buf, len, "%s checker%s", c->cls->name, msg);
>  	return buf;
>  }
>  
> diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
> index 834efcfe..2c71e40c 100644
> --- a/libmultipath/checkers.h
> +++ b/libmultipath/checkers.h
> @@ -145,7 +145,9 @@ int checker_check (struct checker *, int);
>  int checker_selected(const struct checker *);
>  int checker_is_sync(const struct checker *);
>  const char *checker_name (const struct checker *);
> -char *checker_message (const struct checker *);
> +/* checker_message(): returned pointer is malloc()d */
> +char *checker_message(const struct checker *);
> +int checker_has_message(const struct checker *);
>  void checker_clear_message (struct checker *c);
>  void checker_get(const char *, struct checker *, const char *);
>  
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index 467ece7a..0bcd3c39 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -1588,9 +1588,12 @@ get_state (struct path * pp, struct config *conf, int daemon, int oldstate)
>  	condlog(3, "%s: %s state = %s", pp->dev,
>  		checker_name(c), checker_state_name(state));
>  	if (state != PATH_UP && state != PATH_GHOST &&
> -	    strlen(checker_message(c)))
> -		condlog(3, "%s: checker msg is \"%s\"",
> -			pp->dev, checker_message(c));
> +	    checker_has_message(c)) {
> +		char *msg = checker_message(c);
> +
> +		condlog(3, "%s: checker msg is \"%s\"", pp->dev, msg);
> +		FREE(msg);
> +	}
>  	return state;
>  }
>  
> diff --git a/multipathd/main.c b/multipathd/main.c
> index e80ac906..fcf0d2db 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -95,14 +95,13 @@ do {								\
>  		if (pp->offline)				\
>  			condlog(lvl, "%s: %s - path offline",	\
>  				pp->mpp->alias, pp->dev);	\
> -		else {						\
> -			const char *__m =			\
> +		else if (checker_has_message(&pp->checker)) {	\
> +			char *__m =				\
>  				checker_message(&pp->checker);	\
>  								\
> -			if (strlen(__m))			\
> -				condlog(lvl, "%s: %s - %s",	\
> -					pp->mpp->alias,		\
> -					pp->dev, __m);		\
> +			condlog(lvl, "%s: %s - %s",		\
> +				pp->mpp->alias, pp->dev, __m);	\
> +			FREE(__m);				\
>  		}						\
>  	}							\
>  } while(0)
> -- 
> 2.19.1
